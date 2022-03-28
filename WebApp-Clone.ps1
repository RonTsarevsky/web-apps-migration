$source_asp = Get-AzAppServicePlan -ResourceGroupName "cloneproj" -Name "p3v2"
$get_asp = Get-AzAppServicePlan -ResourceGroupName "cloneproj" -Name "clone-app-service-plan"
$apps = Get-AzWebApp | Where-Object { $_.ServerFarmId -eq $source_asp.Id }
$pfxPath = "/home/ron/certificate.pfx"
$pfxPassword = "ron13121997"
$pfxPathAzri = ""   
$pfxPasswordAzri = ""
$AzriWebApp = Get-AzWebApp -ResourceGroupName "" -Name "" | Where-Object { $_.ServerFarmId -eq $source_asp.Id }


$apps | ForEach {
    $fqdn =  ($_.HostNames -ne $_.DefaultHostName | Out-String) -replace '\s',''
    $rname = $_.name+"v3"
    $SSLbindCheck = Get-AzWebAppSSLBinding -ResourceGroupName $_.ResourceGroup -WebAppName $_.Name
    if ($SSLbindCheck -ne $null){
        #removes SSL bind and custom domain
        Remove-AzWebAppSSLBinding -ResourceGroupName $_.ResourceGroup -WebAppName $_.Name -Name $fqdn -DeleteCertificate $false
        $_.HostNames.Clear()
        $_.Hostnames.Add($_.DefaultHostName)
        set-AzureRmWebApp -ResourceGroupName $_.ResourceGroup -Name $_.Name -HostNames $_.HostNames
        #clone
        New-AzWebApp -ResourceGroupName $_.ResourceGroup -name $rname -location  $_.Location -AppServicePlan $get_asp.Id -SourceWebApp $_ -IncludeSourceWebAppSlots
        #Adds custom domain  
        Set-AzWebApp -ResourceGroupName $_.ResourceGroup -Name $rname -HostNames $fqdn
        #SSL bind 
        if ($_ -eq $AzriWebApp){
            New-AzWebAppSSLBinding -WebAppName $rname -ResourceGroupName $_.ResourceGroup -Name $fqdn `
            -CertificateFilePath $pfxPathAzri -CertificatePassword $pfxPasswordAzri -SslState SniEnabled
        }else {
            New-AzWebAppSSLBinding -WebAppName $rname -ResourceGroupName $_.ResourceGroup -Name $fqdn `
            -CertificateFilePath $pfxPath -CertificatePassword $pfxPassword -SslState SniEnabled
        }
    }else {
        New-AzWebApp -ResourceGroupName $_.ResourceGroup -name $rname -location  $_.Location -AppServicePlan $get_asp.Id -SourceWebApp $_ -IncludeSourceWebAppSlots

    }

}




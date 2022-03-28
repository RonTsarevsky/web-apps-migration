$source_asp = Get-AzAppServicePlan -ResourceGroupName "cloneproj" -Name "p3v2"
$get_asp = Get-AzAppServicePlan -ResourceGroupName "cloneproj" -Name "clone-app-service-plan"
$apps = Get-AzWebApp | Where-Object { $_.ServerFarmId -eq $source_asp.Id }
$pfxPath = "/home/ron/certificate.pfx"
$pfxPassword = "ron13121997"
$pfxPathAzri = ""   
$pfxPasswordAzri = ""
$AzriWebApp = Get-AzWebApp -ResourceGroupName "" -Name "" | Where-Object { $_.ServerFarmId -eq $source_asp.Id }




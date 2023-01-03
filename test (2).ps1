
$myURL="https://go.microsoft.com/fwlink/?linkid=2088631"
$myOutFile="C:\temp\dotnet.4.8.exe"
$ProgressPreference = 'SilentlyContinue'
$cuFile = "C:\temp\controlup.zip"
$errorfile = "C:\temp\erroroutput.txt"
$version_check = "https://www.controlup.com/latest-agent-console/"
New-Item -Path 'C:\temp' -ItemType Directory
$latestcu = $(Invoke-WebRequest -Uri $version_check -UseBasicParsing  )
$latestcu2 = $($latestcu.Content | ConvertFrom-Json)
$latest_url = $latestcu2.Console

# $ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $latest_url -OutFile $cuFile -UseBasicParsing >> $errorfile

        


$response = Invoke-WebRequest $myURL -UseBasicParsing
[IO.File]::WriteAllBytes($myOutFile, $response.Content)

Write-Host "Installing 4.8"
Start-Process C:\temp\dotnet.4.8.exe -ArgumentList "/q /norestart /log c:\temp\" -Wait 
Write-Host "Installed 4.8 $LASTEXITCODE"

Expand-Archive "C:\temp\controlup.zip" -DestinationPath "C:\temp\controlup"
# Start-Process "C:\temp\controlup\ControlUpConsole.exe" -Wait
# $ProgressPreference = 'Continue'



Restart-Computer
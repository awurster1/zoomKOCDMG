#Define Zoom install location
$zoomapp = "C:\Program Files (x86)\Zoom\bin\Zoom.exe"
$zoomappalt = "$env:userprofile\AppData\Roaming\Zoom\bin\Zoom.exe"

#Define Web browser install location(s)
$chrome = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
$chrome64 = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$firefox64 = "C:\Program Files\Mozilla Firefox\firefox"
$firefox32 = "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"

#Install Zoom via msi installer if not installed
if ((!(Test-Path $zoomapp)) -or (!(Test-Path $zoomappalt))) {
If (!(Test-Path $env:HOMEDRIVE\Temp)) {
Set-Location $env:HOMEDRIVE
New-Item -Path "C:\" -Name "Temp" -ItemType "directory"
}
If ((Test-Path $env:HOMEDRIVE\Temp) -and (Test-Path C:\Temp\ZoomInstallerFull.msi)) {
Set-Location $env:HOMEDRIVE\Temp
Start-Process "msiexec.exe" -Wait -ArgumentList '/I C:\Temp\ZoomInstallerFull.msi ZRecommend="Disablevideo=1" ZRecommend="MuteVoipWhenJoin=1" /norestart'
Remove-Item 'C:\Temp\ZoomInstallerFull.msi'
}
}
#Define zoom arguments based on user input
$prompt = Read-Host -Prompt "DMG or K of C Zoom Meeting? ('y' for DMG or KoC, 'n' to enter manual meeting ID)"
#converting input to lower to prevent errors
$prompt = $prompt.ToLower()

if ($prompt -eq "y") {
$zoomargs="--url=zoommtg://zoom.us/join?action=join&confno=99119098914&pwd=2xQrcF"
$zoominstargs="https://zoom.us/j/99119098914?pwd=2xQrcF"
}
elseif ($prompt -eq "n") {
$manual = Read-Host -Prompt "Enter Zoom ID; NO SPACES"
$manpwd = Read-Host -Prompt "Enter password if needed; otherwise, leave blank"
$zoomargs="--url=zoommtg://zoom.us/join?action=join&confno="
$zoominstargs="https://zoom.us/j/"
}
if (($manpwd -eq "") -or ($manpwd -eq " ")) {
$zoomargs = $zoomargs + $manual
$zoominstargs="https://zoom.us/j/" + $manual
}
elseif ((!($manpwd -eq "")) -or (!($manpwd -eq " "))) {
$zoomargs = $zoomargs + $manual + '&pwd=' + $manpwd
$zoominstargs="https://zoom.us/j/" + $manual + '?pwd=' + $manpwd
}


#Launch Zoom Meeting (By any means)
if (Test-Path $zoomapp) {
Write-Host "Primary Zoom found; Launching Application"
Start-Sleep -Seconds 1
Start-Process -FilePath $zoomapp -ArgumentList $zoomargs
}
elseif (Test-Path $zoomappalt) {
Write-Host "Primary Zoom not found; using AppData install location"
Start-Sleep -Seconds 5
Start-Process -FilePath $zoomappalt -ArgumentList $zoomargs
}
else {
Write-Host "Neither Zoom App found; launching from web browser"

#Logic to prioritize chrome, then firefox, then edge; And check if they are installed

if (Test-Path $chrome) {
Start-Process -FilePath $chrome -ArgumentList $zoominstargs
}
elseif (Test-Path $chrome64) {
Start-Process -FilePath $firefox64 -ArgumentList $zoominstargs
}
elseif (Test-Path $firefox64) {
Start-Process -FilePath $firefox64 -ArgumentList $zoominstargs
}
elseif (Test-Path $firefox32) {
Start-Process -FilePath $firefox32 -ArgumentList $zoominstargs
}
elseif (Test-Path $edge) {
Start-Process -FilePath $edge -ArgumentList $zoominstargs
}
else {
Start-Sleep -Seconds 5
Write-Host "No web browser installed; Exiting."
exit
}

}
if ($prompt -eq "y") {
Start-Sleep -Seconds 1
msg $env:username /TIME:60 /V 'KOC/DMG Password: ' '2xQrcF'
}
elseif (!($prompt -eq "y")) {
#Nothing happens
}


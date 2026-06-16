del C:\Windows\wlanr\*.xml, C:\Windows\wlanr\wlanr.ps1

$diretorioScript = $PSScriptRoot

$arquivo1 = Join-Path -Path $diretorioScript -ChildPath "Wi-Fi-rede_escola.xml"
$arquivo2 = Join-Path -Path $diretorioScript -ChildPath "wlanr.ps1"

$destino = "C:\Windows\wlanr"

copy -Path $arquivo1, $arquivo2 -Destination $destino

netsh wlan delete profile name="rede_escola"

C:\Windows\wlanr\wlanr.ps1
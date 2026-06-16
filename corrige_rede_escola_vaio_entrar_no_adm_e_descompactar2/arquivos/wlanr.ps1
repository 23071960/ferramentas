$teste = netsh wlan show profiles name="rede_escola" | findstr "Enterprise"

if (-not $teste) {

    netsh wlan delete profile name="rede_escola"

	regedit /s C:\Windows\wlanr\rede_escola.reg

    $nomeperfil = (Get-ChildItem -Path C:\Windows\wlanr\ -Recurse -Include *.xml).BaseName

	netsh wlan add profile filename="C:\Windows\wlanr\$nomeperfil.xml"

	$nomeregistro = (Get-ChildItem -Path C:\Windows\wlanr\ -Recurse -Include *.txt).BaseName

	$perfilwifi = Get-ChildItem -Path "C:\ProgramData\Microsoft\Wlansvc\Profiles\Interfaces" -Recurse | Select-String -Pattern 'rede_escola'

	$padrao = '\{[^}]*\}'

	$matches = "$perfilwifi" | Select-String -Pattern $padrao -AllMatches | ForEach-Object { $_.Matches }

	$idperfil = $matches[1].Value

	Rename-Item -Path "HKLM:SOFTWARE\Microsoft\WlanSvc\Profiles\$nomeregistro" -NewName "$idperfil"

}
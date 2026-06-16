@echo off

set DIRETORIO_PS1=%~dp0

powershell.exe Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force ; "%DIRETORIO_PS1%arquivos\corrige_rede_escola_vaio.ps1"

exit
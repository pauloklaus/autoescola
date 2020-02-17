@echo off
Set Sistema=XYZX YZXYZX
Set Linha=ฤฤฤฤฤฤฤฤฤฤฤ
Set Pasta=XYZXYZX
Set Executavel=XYZXYZX
echo  ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ%Linha%ฤฤฟ
echo  ณ Instalao do Sistema [%Sistema%] ณ
echo  ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ%Linha%ฤฤู
echo.
if not exist %Executavel%.exe goto Erro

echo    þ Criando Pasta de Trabalho
echo      [C:\%Pasta%]
md C:\%Pasta% > Nul
echo.
echo    þ Copiando Arquivo de Programa
echo      [C:\%Executavel%.exe]
Copy %Executavel%.exe C:\%Pasta% /y /v > Nul
echo.
echo  ษอออออออออออออออออออออออออออออออออออออออป
echo  บ O SISTEMA FOI INSTALADO COM SUCESSO ! บ
echo  ศอออออออออออออออออออออออออออออออออออออออผ
echo.
echo  Para execut -lo, v  at a pasta C:\%Pasta%, e execute o arquivo %Executavel%
echo  * Qualquer dฃvida, entre em contato com Paulo Sergio Klaus !
goto Fim

:Erro
echo  ษออออออออออออออออออออออออป
echo  บ INSTALA€O CANCELADA ! บ
echo  ศออออออออออออออออออออออออผ
echo.
echo  * O Arquivo de instalao %Executavel%.exe no foi encontrado,
echo    ou no pode ser acessado.

:Fim
Set Sistema=
Set Linha=
Set Pasta=
Set Executavel=
echo.

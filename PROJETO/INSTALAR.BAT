@echo off
Set Sistema=XYZX YZXYZX
Set Linha=컴컴컴컴컴�
Set Pasta=XYZXYZX
Set Executavel=XYZXYZX
echo  旼컴컴컴컴컴컴컴컴컴컴컴�%Linha%컴�
echo  � Instala뇙o do Sistema [%Sistema%] �
echo  읕컴컴컴컴컴컴컴컴컴컴컴�%Linha%컴�
echo.
if not exist %Executavel%.exe goto Erro

echo    � Criando Pasta de Trabalho
echo      [C:\%Pasta%]
md C:\%Pasta% > Nul
echo.
echo    � Copiando Arquivo de Programa
echo      [C:\%Executavel%.exe]
Copy %Executavel%.exe C:\%Pasta% /y /v > Nul
echo.
echo  �袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴敲
echo  � O SISTEMA FOI INSTALADO COM SUCESSO ! �
echo  훤袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴�
echo.
echo  Para execut�-lo, v� at� a pasta C:\%Pasta%, e execute o arquivo %Executavel%
echo  * Qualquer d즪ida, entre em contato com Paulo Sergio Klaus !
goto Fim

:Erro
echo  �袴袴袴袴袴袴袴袴袴袴袴袴�
echo  � INSTALA�랳 CANCELADA ! �
echo  훤袴袴袴袴袴袴袴袴袴袴袴暠
echo.
echo  * O Arquivo de instala뇙o %Executavel%.exe n꼘 foi encontrado,
echo    ou n꼘 pode ser acessado.

:Fim
Set Sistema=
Set Linha=
Set Pasta=
Set Executavel=
echo.

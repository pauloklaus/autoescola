*****************************************************************************
*****************************************************************************
***
***   Funcoes Avancadas para Clipper 5.3
***   Paulo Sergio Klaus
***   FUNCOES.PRG
***
*****************************************************************************
*****************************************************************************

*****************************
*****************************
*
*  Bloco INFORMACOES DO SISTEMA
*
Function SisInfo()
_AjTexto:=""
Formulario( {{,6,18,12,44,"Informa‡”es ...",_CorNormal},  {2,1,,2,3,6,38}, {1,1,,3,5,_SisDescr+";Desenvolvido por "+_SisPsk+';Vers„o 1.0;;Para uso de "'+_SisLicen+'"',0}, {8,1,,10,33," Ok ",3}} )
Return(0)
*
*  Fim do Bloco INFORMACOES DO SISTEMA
*
*****************************
*****************************
*
*
*
*
*
*
*
*
*
*
*****************************
*****************************
*
*  Bloco CONFIGURACAO DO AMBIENTE
*
Function CfgAmbient()
Local _CLocal1
Private _CPriv1:={_SisCfg[1], _SisCfg[2], _SisCfg[3], _SisCfg[4], _SisCfg[5], _SisCfg[6], _SisCfg[7], _SisCfg[8], _SisCfg[9], _SisCfg[10], _SisCfg[11], _SisCfg[12]}
_AjTexto:="Configura‡”es do Ambiente;;Altere os padr”es de apresenta‡„o com este recurso.;Para modificar a cor de um  item  da  lista,  selecione-o e;ap¢s tecle <Tab>. Ent„o ‚ s¢ teclar setas para os lados  ou;setas para cima e para baixo para escolher uma  determinada;cor.;;Tamb‚m ‚ poss¡vel alterar o  papel  de  parede.  Para  isso;selecione um t¡tulo na lista Papel de Parede.;;Para aplicar as mudan‡as, acione a op‡„o [Ok] !"
If Formulario({{,4,10,17,60,"Configura‡”es do Ambiente",_CorNormal},  {1,1,,2,3,"Selecione um Item"+Space(12)+"Papel de Parede",0},  {6,1,"ConfAmbL1",3,3,5,25,1,{"T¡tulo do Sistema","Janela de Apresenta‡„o","  Objetos selecionados","  Outros Objetos","Janela de Alerta","  Objetos selecionados","  Outros Objetos","Janela de Ajuda","  Objetos selecionados","  Outros Objetos","Papel de Parede"},0},   {7,1,"ConfAmbCr",10,2,_CPriv1[1],0},   {6,1,"ConfAmbL2",3,32,5,24,Val(_CPriv1[12]),{Chr(176)+" Preenchimento1", Chr(177)+" Preenchimento2", Chr(178)+" Preenchimento3", Chr(220)+Chr(223)+" Malha", "Nenhum"},0},  {8,1,,15,23," Ok ",1}, {8,1,"ConfAmbPd",15,33,"Padr„o",0}, {8,1,,15,45,"Cancelar",2}})==6
    For _CLocal1:=1 to 12
        _SisCfg[_CLocal1]:=_CPriv1[_CLocal1]
    next
    _CPriv1:=FormMens(,"O sistema ser  reinicializado ...",_CorNormal,0)
    Set(14,0) // Set Type to 0
    SalvaCfg()
    Inkey(0.5)
    Set(14,1) // Set Type to 1
    RestScreen(_CPriv1[1], _CPriv1[2], _CPriv1[3], _CPriv1[4], _CPriv1[5])
    Release _CPriv1
    SisFim()
    SetCursor(1)
    If SisInicio()<>0
        SisFim("þ Erro ao reiniciar sistema !")
        __Quit()
    end
end
Return(1)

*
* Altera as barras de cores para as cores do item selecionado na lista
*
Function ConfAmbL1(_Cod)
If _Cod==2
    _FObjeto[4,6]:=_CPriv1[_FObjeto[3,8]]
    Form_Obj({4})
end
Return(0)

*
* Altera o Papel de Parede Selecionado
*
Function ConfAmbL2(_Cod)
If _Cod==2
    _CPriv1[12]:=Str(_FObjeto[5,8],5)
end
Return(0)

*
* Altera a cor armazenada em _CPriv1 pela cor do elemento
* selecionado na lista
*
Function ConfAmbCr(_Cod)
If _Cod==2
    _CPriv1[_FObjeto[3,8]]:=_FObjeto[4,6] // Objeto 4 ‚ a barra de cores
end
Return(0)

*
* Atribui as configuracoes padroes
*
Function ConfAmbPd(_Cod)
If _Cod==2
    _CPriv1:={_SisCfgPdr[1], _SisCfgPdr[2], _SisCfgPdr[3], _SisCfgPdr[4], _SisCfgPdr[5], _SisCfgPdr[6], _SisCfgPdr[7], _SisCfgPdr[8], _SisCfgPdr[9], _SisCfgPdr[10], _SisCfgPdr[11], _SisCfgPdr[12]}
    _FObjeto[5,8]:=Val(_SisCfgPdr[12]) // Papel de Parede
    Form_Obj({5})
    ConfAmbL1(2)
    _FormAcao:=9
end
Return(0)
*
*  Fim do Bloco CONFIGURACAO DO AMBIENTE
*
*****************************
*****************************
*
*
*
*
*
*
*
*
*
*
*****************************
*****************************
*
*  Bloco CONFIGURACOES DE IMPRESSAO
*
Function CfgImpr()
_AjTexto:="Configura‡”es de Impress„o;;As configura‡”es de impress„o, s„o aplicadas  em  todos  os;relat¢rios gerados por este  Sistema.  Para  configurar  as;op‡”es de impress„o est„o dispon¡veis os seguintes valores:;;    Porta de Comunica‡„o (Lpt1 ou Lpt2);    Quantidades de linhas (10 a 99 por p gina);    Espa‡o entre linhas (1 a 99 p¡xeis);    Margens (0 a 10 caracteres);    Qualidade de Impress„o (Rascunho ou Carta);    Fonte de Letra (Roman ou SansSerif);    Caracteres por Polegada (10 ou 12 Cpp);;Este sistema ‚ capaz de Emular impressoras Epson."
Formulario( {{,6,11,14,56,"Configura‡”es de Impress„o",_CorNormal}, {1,1,,2,3,"Emula‡„o [Epson];"+Space(34)+"Margens;Porta de Comunica‡„o, LPT"+Space(10)+"Superior ..;Linhas na P gina ......."+Space(11)+"Esquerda ..;Espa‡o entre Linhas ...."+Space(11)+"Direita ...;;Qualidade"+Space(8)+"Fonte de Letra"+Space(5)+"Carac. p/ Poleg.",0}, {3,1,"ConfImprVer",4,28,SubStr(_SisCfg[13],5,1),3}, {3,1,"ConfImprVer",5,28,SubStr(_SisCfg[14],4,2),3}, {3,1,"ConfImprVer",6,28,SubStr(_SisCfg[15],4,2),3}, {3,1,"ConfImprVer",4,50,SubStr(_SisCfg[16],4,2),3}, {3,1,"ConfImprVer",5,50,SubStr(_SisCfg[17],4,2),3}, {3,1,"ConfImprVer",6,50,SubStr(_SisCfg[18],4,2),3}, {5,1,,9,3,Val(_SisCfg[19]),{"Rascunho","Carta"}}, {5,1,,9,20,Val(_SisCfg[20]),{"Roman","SansSerif"}}, {5,1,,9,39,Val(_SisCfg[21]),{"10 Cpi","12 Cpi"}}, {8,1,"ConfImprOk",12,19," Ok ",1}, {8,1,"ConfImprPd",12,29,"Padr„o",0}, {8,1,,12,41,"Cancelar",2}} )
Return(0)

*
* SubFuncao para Verificar se os parametros digitados em
* Cfg_Impr(), sao validos !
*
Function ConfImprVer(_Cod)
If _Cod==3
    If _FOAtual==3
        If Val(_FObjeto[3,6])<1
            _FObjeto[3,6]:="1"
        ElseIf Val(_FObjeto[3,6])>2
            _FObjeto[3,6]:="2"
        End
    ElseIf _FOAtual==4 .or. _FOAtual==5
        If Val(_FObjeto[_FOAtual,6])<10
            _FObjeto[_FOAtual,6]:="10"
        end
    ElseIf _FOAtual>=6 .and. _FOAtual<=9
        If Val(_FObjeto[_FOAtual,6])>10
            _FObjeto[_FOAtual,6]:="10"
        end
    end
    Form_Obj({_FOAtual})
end
Return(0)

*
* SubFuncao para salvar as informacoes e fechar esta janela
*
Function ConfImprOk(_Cod)
If _Cod==2
    _SisCfg:={_SisCfg[1], _SisCfg[2], _SisCfg[3], _SisCfg[4], _SisCfg[5], _SisCfg[6], _SisCfg[7], _SisCfg[8], _SisCfg[9], _SisCfg[10], _SisCfg[11], _SisCfg[12], Space(4)+_FObjeto[3,6], Space(3)+_FObjeto[4,6], Space(3)+_FObjeto[5,6], Space(3)+_FObjeto[6,6], Space(3)+_FObjeto[7,6], Space(3)+_FObjeto[8,6], Str(_FObjeto[9,6],5), Str(_FObjeto[10,6],5), Str(_FObjeto[11,6],5)}
    Sis_Cfg()
    SalvaCfg()
    _FormAcao:=2
end
Return(0)

*
* SubFuncao para voltar aos valores padroes as opcoes de CfgImpr()
*
Function ConfImprPd(_Cod)
If _Cod==2
    _FObjeto[3,6]:=SubStr(_SisCfgPdr[13],5,1)
    _FObjeto[4,6]:=SubStr(_SisCfgPdr[14],4,2)
    _FObjeto[5,6]:=SubStr(_SisCfgPdr[15],4,2)
    _FObjeto[6,6]:=Alltrim(_SisCfgPdr[16])+Chr(32)
    _FObjeto[7,6]:=Alltrim(_SisCfgPdr[17])+Chr(32)
    _FObjeto[8,6]:=Alltrim(_SisCfgPdr[18])+Chr(32)
    _FObjeto[9,6]:=Val(_SisCfgPdr[19])
    _FObjeto[10,6]:=Val(_SisCfgPdr[20])
    _FObjeto[11,6]:=Val(_SisCfgPdr[21])
    Form_Obj({3,4,5,6,7,8,9,10,11})
    _FormAcao:=9
end
Return(0)
*
*  Fim do Bloco CONFIGURACOES DE IMPRESSAO
*
*****************************
*****************************
*
*
*
*
*
*
*
*
*
*
*****************************
*****************************
*
*  Bloco AJUDA AO USUARIO
*
Function SisAjuda()
_AjTexto:="Menu do Sistema;;As op‡”es dos menus, disponibilizam ao  usu rio,  um  amplo;controle deste sistema de informa‡„o. Atrav‚s destas op‡”es;‚ poss¡vel adaptar o sistema  para  uso  pr¢prio,  al‚m  do;controle abrangente sobre Bancos de Dados !"
FormAj(0)
Return(0)
*
*  Fim do Bloco AJUDA AO USUARIO
*
*****************************
*****************************
*
*
*
*
*
*
*
*
*
*
*****************************
*****************************
*
*  Bloco ENCERRAMENTO DO SISTEMA
*
Function SisFechar()
_AjTexto:="Encerramento do Sistema !;;Vocˆ quer finalizar o Sistema ? Bem, se  realmente  quiser,;acione o bot„o (Sim), mas se desejar  retornar  ao  Sistema;acione (N„o) !"
If FormMens("Finalizar tarefas !","Deseja encerrar este Sistema ?",_CorNormal,2)==1
    _SMenuAcao:=8
end
Return(0)
*
*  Fim do Bloco ENCERRAMENTO DO SISTEMA
*
*****************************
*****************************
*
*
*
*
*
*
*
*
*
*
*****************************************************************************
*
*  Funcao para Salvar as Informacoes de Configuracao
*
Function SalvaCfg()
Local _SLocal1, _SLocal2:="SISTEMA.CFG", _SLocal3:=1,;
      _SLocal4:=Chr(13)+Chr(10)+"Configura‡”es."+Chr(13)+Chr(10)+Chr(26),;
      _SLocal5
*
Whil .t.
    _SLocal1:=If(File(_SLocal2), FOpen(_SLocal2,18), FCreate(_SLocal2,0) )
    If FError()<>0
        Exit
    end
    *
    For _SLocal5:=1 to 21
        _SLocal4:=_SLocal4+Enc(_SisCfg[_SLocal5], 12)
    next
    *
    FSeek(_SLocal1, 0, 0)
    If FWrite(_SLocal1, _SLocal4, Len(_SLocal4)) == Len(_SLocal4)
        _SLocal3:=0
    end
    Exit
end
FClose(_SLocal1)
Return(_SLocal3)
*
*
*
*
*
*
*
*
*
*
*****************************************************************************
*
*  Funcao para Recuperar as Informacoes de Configuracao
*
Function RecupCfg()
Local _RLocal1, _RLocal2:="SISTEMA.CFG", _RLocal3:=1, _RLocal4:=Space(124)
*
Whil .t.
    If !File(_RLocal2)
        Exit
    end
    _RLocal1:=FOpen(_RLocal2, 18)
    If FError()<>0
        Exit
    end
    If FRead(_RLocal1, @_RLocal4, 124) <> 124
        Exit
    end
    *
    _RLocal4:=SubStr(_RLocal4,20)
    For _RLocal3:=1 to 21
        _SisCfg[_RLocal3]:=Enc( SubStr(_RLocal4, (_RLocal3*5)-4, 5), 12, 1)
    next
    _RLocal3:=0
    Exit
end
FClose(_RLocal1)
If _RLocal3<>0
    For _RLocal3:=1 to 21
        _SisCfg[_RLocal3]:=_SisCfgPdr[_RLocal3]
    next
end
Return(_RLocal3)
*
*
*
*
*
*
*
*
*
*
*****************************************************************************
*
*  Retorna a data por extenso, no formato:
*  Dia da semana, 00 de mes de 0000.
*
Function ExtensoDat(_EParam1)
Local _ELocal1:={"Domingo","Segunda-feira","Ter‡a-feira","Quarta-feira","Quinta-feira","Sexta-feira","S bado"},;
      _ELocal2:={"janeiro","fevereiro","mar‡o","abril","maio","junho","julho","agosto","setembro","outubro","novembro","dezembro"}
Return( _ELocal1[DoW(_EParam1)]+", "+Alltrim(Str(Day(_EParam1)))+" de "+_ELocal2[Month(_EParam1)]+" de "+Alltrim(Str(Year(_EParam1))) )
*
*
*
*
*
*
*
*
*
*
*****************************************************************************
*
*  Funcao para Encriptar/desEncriptar uma String de texto
*
Function Enc(_EParam1, _EParam2)
Local _ELocal1:=Len(_EParam1), _ELocal2:="", _ELocal3, _ELocal4:=If(PCount()>2, _EParam2, _EParam2-(_EParam2*2))
For _ELocal3:=1 to _ELocal1
    _ELocal2:=_ELocal2+Chr(Asc(SubStr(_EParam1, _ELocal3, 1))+_ELocal4)
next
_EParam1:=""
For _ELocal3:=_ELocal1 to 1 step -1
    _EParam1:=_EParam1+SubStr(_ELocal2, _ELocal3, 1)
next
Return(_EParam1)

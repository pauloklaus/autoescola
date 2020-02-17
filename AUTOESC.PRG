*****************************************************************************
*****************************************************************************
***
***   Sistema para Auto Escolas
***   Paulo Sergio Klaus
***   AUTOESC.PRG
***
*****************************************************************************
*****************************************************************************
*
*  Bloco INICIALIZACAO
*
SetCancel(.f.)
Public _SisDos     // Armazena a tela e a linha do DOS
*
*  Fim do Bloco INICIALIZACAO
*
*****************************


*****************************
*
*  Bloco ARQUIVOS DEPENDENTES
*  -> Prgs Denpendentes
*
_ProcReq_( ".\Projeto\Sistema.prg" )
_ProcReq_( ".\Projeto\Form.prg" )
_ProcReq_( ".\Projeto\Menus.prg" )
_ProcReq_( ".\Projeto\Funcoes.prg" )
_ProcReq_( ".\Projeto\BDados.prg" )
*
*  Fim do Bloco ARQUIVOS DEPENDENTES
*
*****************************


*****************************
*
*  Bloco VARIAVEIS
*  -> Variaveis do Sistema
*
Public _SisPsk:=Enc("øúæñÐ¥ôîì÷êØ¥ôñúæÕ",133),;
       _SisDescr:="Sistema para Auto Escola",;
       _SisLicen:="Auto Escola Princesa",;
       _SisHora:={,1}, _SisCfg[21], _SisLstPap, _SisPapel,;
       _SisCfgPdr:=If(IsColor(), {"15/00", "15/09", "01/15", "01/07", "15/04", "04/15", "04/07", "15/02", "02/15", "10/07", "01/00", Space(4)+"1", Space(4)+"1", Space(3)+"66", Space(3)+"30", Space(4)+"0", Space(4)+"2", Space(4)+"2", Space(4)+"1", Space(4)+"2", Space(4)+"1"},;
                                 {"15/01", "15/01", "00/15", "01/09", "15/01", "00/15", "01/09", "15/01", "00/15", "01/09", "08/00", Space(4)+"1", Space(4)+"1", Space(3)+"66", Space(3)+"30", Space(4)+"0", Space(4)+"2", Space(4)+"2", Space(4)+"1", Space(4)+"2", Space(4)+"1"})
*
Public _AjTexto:="", _AjUso:=0, _AjCabec:="", _AjIntro,;
       _CorTitulo, _CorNormal, _CorAtenc, _CorAj, _CorPapel,;
       _ImpLpt, _ImpLinhas, _ImpEspLin, _ImpMargS, _ImpMargD, _ImpMargE, _ImpQualid, _ImpFonte, _ImpCpi
*
*  Fim do Bloco VARIAVEIS
*
*****************************


*****************************
*
*  Bloco SISTEMA
*  -> Inicio do Sistema
*
RecupCfg()
If SisInicio()<>0
    Return(0)
end

    *****************************
    *
    *  SubBloco CONFIGURACOES DOS MENUS
    *  -> Declaracao de Variaveis
    *
    Public  _SisMenu:={;
                      { 0,  0, "Sistema",  0,  0, 0, 0, 1, {{0,"Informa‡”es",,"SisInfo","Informa‡”es do Sistema"}, {0,"Ambiente",,"CfgAmbient","Configura‡”es do Ambiente do Sistema"}, {0,"Impressora",,"CfgImpr","Configura‡”es para a Impressora"}, {2,"",,,}, {0,"Fechar"+Space(7)+"<Esc>",27,"SisFechar","Encerramento de Sistema"}} },;
                      { 0,  0, "Controles",0,  0, 0, 0, 1, {{0,"Clientes"+Space(3)+"<F2>",-1,"CliControl","Controle de Clientes"},  {0,"Renach"+Space(5)+"<F3>",-2,"RenControl","Controle de Renach's"},  {0,"Dar 19"+Space(5)+"<F4>",-3,"DarControl","Controle de Dar 19"}} },;
                      { 0, 72, "Ajuda",    0, 54, 0, 0, 1, {{0,"Ajuda"+Space(12)+"<F1>",28,"SisAjuda","Ajuda ao usu rio"}, {0,"Introdu‡„o"+Space(2)+"<Ctrl+F1>",-20,"FormAj","Introdu‡„o a este Sistema de Informa‡„o"}, {2,"",,,}, {0,"Calend rio"+Space(6)+"<F10>",-9,"FormCalend","Calend rio do Sistema"}, {0,"Calculadora"+Space(5)+"<F11>",-40,"FormCalc","Calculadora com as quatro opera‡”es Matem ticas"}} };
                      }
    *
    *  Fim do SubBloco CONFIGURACOES DOS MENUS
    *
    *****************************

    *****************************
    *
    *  SubBloco ABERTURA DE BANCO DE DADOS
    *
    Public _BDClient:={,"Autoesc.bd", 1, {{"Nome",1,35,1}, {"Data de Nasc.",36,8,5}, {"Rua",44,50,1}, {"N£mero",94,5,1}, {"Fone",99,10,6}, {"Cidade",109,30,1}, {"Uf",139,2,1}, {"Identidade",141,14,1}, {"Cpf",155,11,7}, {"Categoria",166,6,1}, {"Data 1¦ Habilita‡„o",172,8,5}, {"Data Expedi‡„o",180,8,5}, {"N£m. do Registro",188,12,1}, {"Validade",200,8,5}}, {1,6,7}, 207, 0, {}, 0}
    BDRecup(_BDClient)
    *
    *  Fim do SubBloco ABERTURA DE BANCO DE DADOS
    *
    *****************************

*
*  Inicio do Menu Principal
*
SuperMenu()
SisFim()
Return(0)
*
*  Fim do Bloco SISTEMA
*
*****************************


*****************************************************************************
*****************************************************************************
***
***  Controle de Renach's
***
Function RenControl
Local _FRenSel:=1, _ResultRen:=0
Private _FRenach1:={{,4,2,17,75,"Renach",_CorNormal}, {1,1,,2,3,"Nome (F5 Altera);Data de Nasc.;;Motivo do Preenchimento;;N£mero do Formul rio Anterior;N£mero do Registro;;Categoria Atual"+Space(8)+", Pretendida;;Preenchimento; Local; Data",0}, {3,1,"Ren_Cli",2,20,Space(50),1}, {3,1,,3,17,Space(8),5}, {3,1,"Ren_Mot",5,27,Space(2),3}, {1,1,,5,32,"-> ???",0}, {3,1,,7,33,Space(5),1}, {3,1,,8,22,Space(5),1}, {3,1,,10,19,Space(5),1}, {3,1,,10,39,Space(5),1}, {3,1,,13,10,"CONCORDIA"+Space(6),1}, {3,1,,14,9,StrZero(Day(Date()),2)+StrZero(Month(Date()),2)+StrZero(Year(Date()),4),5}, {8,1,,15,46,"Pr¢ximo",1}, {8,1,,15,60,"Cancelar",2}},;
        _FRenach2:={{,4,3,17,72,"Renach",_CorNormal}, {1,1,,2,3,"Pai;M„e;;Munic¡pio de Nasc."+Space(21)+", Uf"+Space(5)+", C¢digo;Cpf;"+Space(34)+"Org„o Emis."+Space(15)+"Uf;;Nacionalidade"+Space(7)+"Sexo"+Space(14)+"Grau de Instru‡„o"+Space(5)+"Sangue", 0}, {3,1,,2,7,Space(45),1}, {3,1,,3,7,Space(45),1}, {3,1,,5,22,Space(18),1}, {3,1,,5,47,Space(2),1}, {3,1,,5,60,Space(5),1}, {3,1,,6,7,Space(11),7}, {4,1,,7,3,1,"Identidade"}, {3,1,,7,19,Space(15),1}, {3,1,,7,49,Space(10),1}, {3,1,,7,66,Space(2),1}, {5,1,,10,3,1,{"Brasileiro", "Naturalizado", "Estrangeiro"}}, {5,1,,10,23,1,{"Masculino", "Feminino"}}, {6,1,,10,41,3,19,1,{"1§ G. Incompleto", "1§ G. Completo", "2§ G. Incompleto", "2§ G. Completo", "3§ G. Incompleto", "3§ G. Completo"},0}, {6,1,,10,63,3,6,1,{"A+ ", "A- ", "B+ ", "B- ", "AB+", "AB-", "O+ ", "O- ","   "},0}, {8,1,,15,42,"Pr¢ximo",1}, {8,1,,15,27,"Anterior",0}, {8,1,,15,56,"Cancelar",2}}
Private _FRenach3:={{,4,3,17,72,"Renach",_CorNormal}, {1,1,,2,3,"Doador de Org„os;;;;;Log"+Space(6)+", Logadouro"+Space(38)+",;Complemento;Bairro;Uf;Munic¡pio;Fone;C¢digo do Munic¡pio",0}, {5,1,,3,3,1,{"Sim","N„o","Em Branco"}}, {3,1,,7,7,"RUA",1}, {3,1,,7,24,Space(35),1}, {3,1,,7,63,Space(5),1}, {3,1,,8,15,Space(15),1}, {3,1,,9,15,Space(25),1}, {3,1,,10,15,Space(2),1}, {3,1,,11,15,Space(30),1}, {3,1,,12,15,Space(10),6}, {3,1,,13,23,Space(5),1}, {8,1,,15,42,"Pr¢ximo",1}, {8,1,,15,27,"Anterior",0}, {8,1,,15,56,"Cancelar",2}},;
        _MotSel:=1, _MotLista:={"Primeira Habilita‡„o", "Segunda Via", "Registro Estrangeiro", "Registro", "Renova‡„o", "Mudan‡a de Categoria", "Adi‡„o", "Altera‡„o", "Reabilita‡„o", "Erro Detran", "Erro Banco Imagem"},;
        _RenAj:="Renach;;O  Renach  permite  imprimir  um  documento  necess rio   a;CNH (Carteira Nacional de Habilita‡„o).;;Para isso, percorra as trˆs etapas do  Renach  e  por  fim,;acione a op‡„o [Imprimir]."
*
_AjTexto:=_RenAj
Whil .t.
    If _FRenSel==1      // Primeira Etapa
        _ResultRen:=Formulario(_FRenach1)
        _FRenSel:=If(_ResultRen==13, _FRenSel+1, 0)
        *
    ElseIf _FRenSel==2  // Segunda Etapa
        _FRenach2[1,6]:="Renach de "+_FRenach1[3,6]
        _ResultRen:=Formulario(_FRenach2)
        _FRenSel:=If(_ResultRen==18, _FRenSel-1, If(_ResultRen==17, _FRenSel+1, 0))
        *
    ElseIf _FRenSel==3  // Terceira Etapa
        _FRenach3[1,6]:=_FRenach2[1,6]
        _ResultRen:=Formulario(_FRenach3)
        _FRenSel:=If(_ResultRen==14, _FRenSel-1, If(_ResultRen==13, _FRenSel+1, 0))
        *
    ElseIf _FRenSel==4  // Impressao
        Ren_Impres({_FRenach1[3,6], _FRenach1[4,6], Val(_FRenach1[5,6]), _FRenach1[7,6], _FRenach1[8,6], _FRenach1[9,6], _FRenach1[10,6], _FRenach1[11,6], _FRenach1[12,6],;
                    _FRenach2[3,6], _FRenach2[4,6], _FRenach2[5,6], _FRenach2[6,6], _FRenach2[7,6], _FRenach2[8,6], If(_FRenach2[9,6]==1,"1"," "), _FRenach2[10,6], _FRenach2[11,6], _FRenach2[12,6], Str(_FRenach2[13,6],1), Str(_FRenach2[14,6],1), Str(_FRenach2[15,8],1), _FRenach2[16,9,_FRenach2[16,8]],;
                    _FRenach3[3,6], _FRenach3[4,6], _FRenach3[5,6], _FRenach3[6,6], _FRenach3[7,6], _FRenach3[8,6], _FRenach3[9,6], _FRenach3[10,6], _FRenach3[11,6], _FRenach3[12,6]})
        _FRenSel:=1
        *
    Else
        Exit
    end
end
Release _FRenach1, _FRenach2, _FRenach3, _RenAj
Return(0)

*
*  Altera o Cliente
*
Function Ren_Cli(_Cod)
Local _RenTemp
If _Cod==1 .and. _FTecla==-4
    CliControl()
    If _BDClient[7]<>0
        _DarTemp:=BDRegistro(_BDClient)
        _FObjeto[ 3,6] :=_DarTemp[ 1]+Space(15) // Nome
        _FObjeto[ 4,6] :=_DarTemp[ 2] // Data Nasc.
        _FObjeto[ 9,6] :=_DarTemp[10] // Categoria Atual
        *
        _FRenach2[ 8,6]:=_DarTemp[ 9] // Cpf
        _FRenach2[10,6]:=_DarTemp[ 8] // Identidade
        *
        _FRenach3[ 5,6]:=SubStr(_DarTemp[ 3],1,35) // Rua
        _FRenach3[ 6,6]:=_DarTemp[ 4] // Numero
        _FRenach3[ 9,6]:=_DarTemp[ 7] // Uf
        _FRenach3[10,6]:=_DarTemp[ 6] // Municipio
        _FRenach3[11,6]:=_DarTemp[ 5] // Fone
        Form_Obj({3,4,9})
        _FormAcao:=4
    end
    _AjTexto:=_RenAj
end
Return(0)

*
*  Lista com Servicos Solicitados e Codigo do Tributo
*
Function Ren_Mot(_Cod)
Local _FMot
If _Cod==0
    _AjTexto:="Motivo do Preenchimento deste Renach;;Nesta janela, selecione um item da lista para ser  impresso;no Renach. Esta op‡„o indica o Motivo  pelo  qual  se  est ;preenchendo este Documento."
    _FMot:={{,4,43,18,34,"Motivo do Preenchimento",_CorAtenc},  {6,1,"FormPadrao",2,3,12,28,_MotSel,_MotLista,0}, {8,1,,16,3,"Selecionar",1}, {8,1,,16,19,"Cancelar",2}}
    If Formulario(_FMot)==3
        _MotSel:=_FMot[2,8]
        _FObjeto[5,6]:=Str(_MotSel,2)
        _FObjeto[6,6]:="-> "+SubStr(_MotLista[_MotSel]+Space(20),1,20)
        Form_Obj({5,6})
    end
    __Keyboard(Chr(9))
    _AjTexto:=_RenAj
end
Return(0)

*
*  Impressao do Renach
*
Function Ren_Impres(_RCampos)
Local _RJan, _RImp, _RRet:=0, _REnter:=Chr(13)+Chr(10),;
      _FRImpr:={{,9,24,8,32,"Impress„o do Renach",_CorNormal}, {1,1,,2,3,"Formul rio",0}, {5,1,,3,3,1,{"Branco","Verde"}}, {8,1,,6,3,"Imprimir",1}, {8,1,,6,17,"Cancelar",2}}

If Formulario(_FRImpr)==5
    Return(0)
end
*
_RJan:=FormMens(,"Aguarde. Imprimindo Renach ...", _CorNormal, 0)
_RImp:=FOpen(_ImpLpt, 1)
*
If _FRImpr[3,6]==2
    Whil .t.
    If FWrite(_RImp, Chr(27)+Chr(64)+Chr(7)+Chr(27)+Chr(67)+Chr(66)+Chr(27)+Chr(51)+Chr(20)+Chr(27)+Chr(108)+Chr(0)+Chr(27)+Chr(81)+Chr(0)+Chr(27)+Chr(120)+Chr(_ImpQualid)+Chr(27)+Chr(107)+Chr(_ImpFonte)+Chr(27)+Chr(_ImpCpi)+Chr(27)+Chr(69)+Chr(27)+Chr(71))==0
        exit
    end
    *
    If FWrite(_RImp,_REnter+_REnter+_REnter+_REnter+;
        Space(12)+If(_RCampos[3]==1,"1"," ")+Space(16)+If(_RCampos[3]==6,"6"," ")+_REnter+_REnter+;
        Space(12)+If(_RCampos[3]==2,"2"," ")+Space(16)+If(_RCampos[3]==7,"7"," ")+Space(14)+_RCampos[4]+_REnter+;
        Space(29)+If(_RCampos[3]==8,"8"," ")+_REnter+;
        Space(12)+If(_RCampos[3]==3,"3"," ")+_REnter+;
        Space(29)+If(_RCampos[3]==9,"9"," ")+_REnter+;
        Space(12)+If(_RCampos[3]==4,"4"," ")+Space(16)+If(_RCampos[3]==10,"A"," ")+_REnter+;
        Space(12)+If(_RCampos[3]==5,"5"," ")+Space(16)+If(_RCampos[3]==11,"B"," ")+Space(14)+_RCampos[5]+Space(13)+_RCampos[6]+Space(7)+_RCampos[7])==0
        exit
    end
    *
    If FWrite(_RImp,_REnter+_REnter+_REnter+_REnter+_REnter+_REnter+;
        Space(15)+_RCampos[1]+_REnter+_REnter+_REnter+_REnter+_REnter+;
        Space(11)+_RCampos[10]+_REnter+_REnter+_REnter+_REnter+;
        Space(11)+_RCampos[11]+_REnter+_REnter+_REnter+_REnter+;
        Space(11)+Form_Obj3B(_RCampos[2],5)+Space(3)+_RCampos[12]+Space(10)+_RCampos[13]+Space(1)+_RCampos[14]+Space(3)+Form_Obj3B(_RCampos[15],7)+;
        _REnter+_REnter+_REnter+_REnter+_REnter+;
        Space(35)+_RCampos[16]+Space(1)+_RCampos[17]+Space(10)+_RCampos[18]+Space(6)+_RCampos[19]+;
        _REnter+_REnter+_REnter+_REnter+;
        Space(19)+_RCampos[20]+Space(9)+_RCampos[21]+Space(29)+_RCampos[22]+Space(1)+_RCampos[23]+Space(3)+If(_RCampos[24]==1,"X"," ")+_REnter+_REnter+;
        Space(68)+If(_RCampos[24]==2,"N„o Doador",""))==0
        exit
    end
    *
    If FWrite(_RImp,_REnter+_REnter+;
        Space(11)+_RCampos[25]+Space(2)+_RCampos[26]+Space(21)+_RCampos[27]+;
        _REnter+_REnter+_REnter+_REnter+;
        Space(11)+_RCampos[28]+Space(11)+_RCampos[29]+Space(13)+_RCampos[30]+;
        _REnter+_REnter+_REnter+_REnter+_REnter+;
        Space(11)+_RCampos[31]+Space(16)+Form_Obj3B(_RCampos[32],6)+Space(2)+_RCampos[33]+;
        _REnter+_REnter+_REnter+_REnter+_REnter+_REnter+;
        Space(11)+_RCampos[8]+Space(2)+Form_Obj3B(_RCampos[9],5))==0
        exit
    end
    *
    exit
    end
else
    While .t.
    If FWrite(_RImp, Chr(27)+Chr(64)+Chr(7)+Chr(27)+Chr(67)+Chr(66)+Chr(27)+Chr(51)+Chr(20)+Chr(27)+Chr(108)+Chr(0)+Chr(27)+Chr(81)+Chr(0)+Chr(27)+Chr(120)+Chr(_ImpQualid)+Chr(27)+Chr(107)+Chr(_ImpFonte)+Chr(27)+Chr(_ImpCpi)+Chr(27)+Chr(69)+Chr(27)+Chr(71))==0
        exit
    end
    *
    If FWrite(_RImp,_REnter+_REnter+_REnter+_REnter+_REnter+;
        Space(12)+If(_RCampos[3]==1,"1"," ")+Space(16)+If(_RCampos[3]==6,"6"," ")+_REnter+_REnter+;
        Space(12)+If(_RCampos[3]==2,"2"," ")+Space(16)+If(_RCampos[3]==7,"7"," ")+Space(14)+_RCampos[4]+_REnter+;
        Space(29)+If(_RCampos[3]==8,"8"," ")+_REnter+;
        Space(12)+If(_RCampos[3]==3,"3"," ")+_REnter+;
        Space(29)+If(_RCampos[3]==9,"9"," ")+_REnter+;
        Space(12)+If(_RCampos[3]==4,"4"," ")+Space(16)+If(_RCampos[3]==10,"A"," ")+_REnter+;
        Space(12)+If(_RCampos[3]==5,"5"," ")+Space(16)+If(_RCampos[3]==11,"B"," ")+Space(14)+_RCampos[5]+Space(13)+_RCampos[6]+Space(7)+_RCampos[7])==0
        exit
    end
    *
    If FWrite(_RImp,_REnter+_REnter+_REnter+_REnter+_REnter+_REnter+;
        Space(17)+_RCampos[1]+_REnter+_REnter+_REnter+_REnter+;
        Space(17)+_RCampos[10]+_REnter+_REnter+_REnter+_REnter+;
        Space(17)+_RCampos[11]+_REnter+_REnter+_REnter+_REnter+_REnter+;
        Space(11)+Form_Obj3B(_RCampos[2],5)+Space(3)+_RCampos[12]+Space(10)+_RCampos[13]+Space(1)+_RCampos[14]+Space(3)+Form_Obj3B(_RCampos[15],7)+;
        _REnter+_REnter+_REnter+_REnter+;
        Space(35)+_RCampos[16]+Space(1)+_RCampos[17]+Space(10)+_RCampos[18]+Space(6)+_RCampos[19]+;
        _REnter+_REnter+_REnter+_REnter+_REnter+;
        Space(19)+_RCampos[20]+Space(9)+_RCampos[21]+Space(29)+_RCampos[22]+Space(1)+_RCampos[23]+Space(3)+If(_RCampos[24]==1,"X"," ")+_REnter+_REnter+;
        Space(68)+If(_RCampos[24]==2,"N„o Doador",""))==0
        exit
    end
    *
    If FWrite(_RImp,_REnter+_REnter+;
        Space(11)+_RCampos[25]+Space(2)+_RCampos[26]+Space(21)+_RCampos[27]+;
        _REnter+_REnter+_REnter+_REnter+;
        Space(11)+_RCampos[28]+Space(11)+_RCampos[29]+Space(13)+_RCampos[30]+;
        _REnter+_REnter+_REnter+_REnter+;
        Space(11)+_RCampos[31]+Space(16)+Form_Obj3B(_RCampos[32],6)+Space(2)+_RCampos[33]+;
        _REnter+_REnter+_REnter+_REnter+_REnter+_REnter+;
        Space(11)+_RCampos[8]+Space(2)+Form_Obj3B(_RCampos[9],5))==0
        exit
    end
    *
    exit
    end
end
_RRet:=FWrite(_RImp, Chr(27)+Chr(69)+Chr(27)+Chr(71)+Chr(12))
*
If _RRet==0 // Erro de impressao
    FormMens("Impress„o do Renach","Houve um erro ao imprimir;o Renach !!", _CorAtenc, 1)
end
*
FClose(_RImp)
RestScreen(_RJan[1], _RJan[2], _RJan[3], _RJan[4], _RJan[5])
Return(0)
/*
  0123456789 123456789 123456789 123456789 123456789 123456789 1234567890 0
  1                                                                       1
  2  Nome (F5 Altera) [35                                 ]               2
  3  Data de Nasc. [8         ]                                           3
  4                                                                       4
  5  Motivo do Preenchimento [ 1] -> Primeira Habilitacao                 5
  6                                                                       6
  7  Numero do Formulario Anterior [5    ]                                7
  8  Numero do Registro [5    ]                                           8
  9                                                                       9
 10  Categoria Atual [5    ], Pretendida [5    ]                          10
 11                                                                       11
 12  Preenchimento                                                        12
 13   Local [15             ]                                             13
 14   Data [8         ]                                                   14
 15                                         [ Proximo ]  [ Cancelar ]    15
 16                                                                       16
 17 23456789 123456789 123456789 123456789 123456789 123456789 1234567890 17

  0123456789 123456789 123456789 123456789 123456789 123456789 1234567890 0
  1                                                                       1
  2  Pai [35                                 ]                            2
  3  Mae [35                                 ]                            3
  4                                                                       4
  5  Municipio de Nasc. [18                ], Uf [2 ], Codigo [5    ]     5
  6  Cpf [11            ]                                                 6
  7  (x) Identidade [15             ]  Orgao Emis. [10        ]  Uf [SC]  7
  8                                                                       8
  9  Nacionalidade       Sexo              Grau de Instrucao     Sangue   9
 10  [() Brasileiro]    [() Masculino]   /------------------\  /-----\  10
 11  [( ) Naturalizado]  [( ) Feminino]    I 1§ G. Incompleto I  I A+  I  11
 12  [( ) Estrangeiro]                     I 1§ G. Completo   I  I A-  I  12
 13                                        \------------------/  \-----/  13
 14                                                                       14
 15                          [ Anterior ]  [ Proximo ]  [ Cancelar ]    15
 16                                                                       16
 17 23456789 123456789 123456789 123456789 123456789 123456789 1234567890 17

  0123456789 123456789 123456789 123456789 123456789 123456789 1234567890 0
  1                                                                       1
  2  Doador de Orgaos                                                     2
  3  [(x) Sim]                                                            3
  4  [(x) Nao]                                                            4
  5  [(x) Em Branco]                                                      5
  6                                                                       6
  7  Log [Rua], Logadouro [35                                 ], [5    ]  7
  8  Complemento [15             ]                                        8
  9  Bairro      [25                       ]                              9
 10  Uf          [2 ]                                                     10
 11  Municipio   [30                            ]                         11
 12  Fone        [10            ]                                         12
 13  Codigo do Municipio [5    ]                                          13
 14                                                                       14
 15                          [ Anterior ]  [ Pr¢ximo ]  [ Cancelar ]    15
 16                                                                       16
 17 23456789 123456789 123456789 123456789 123456789 123456789 1234567890 17
*/

*****************************************************************************
*****************************************************************************
***
***  Controle de Dar19
***
Function DarControl
Local _DarTemp, _FDar:={{,4,3,17,73,"Documento de Arrecada‡„o Estadual - DAR 19", _CorNormal},  {1,1,,2,3,"Nome (F5 Altera Nome, Fone e Cpf);;Fone;;Reservado;;Servi‡o Solicitado (F5 Altera);;;Informa‡”es Adicionais",0},  {1,1,,2,47,"C¢d. Tributo;Vencimento;Cpf;Referˆncia;Documento;;Principal ..;Multa ......;Juros ......;Corr. Monet.;;Total ......",0},  {3,1,"Dar_Cli",3,3,Space(35),1},  {3,1,"Dar_Cli",4,8,Space(10),6},  {3,1,,6,13,Space(15),1},  {3,1,"Dar_Serv",9,3,Space(40),1},  {3,1,,12,3,Space(35),1},  {3,1,,13,3,Space(35),1},  {3,1,,14,3,Space(35),1},  {3,1,,15,3,Space(35),1},  {3,1,"Dar_Serv",2,60,Space(4),3},  {3,1,,3,59,Space(8),5},  {3,1,"Dar_Cli",4,51,Space(11),7},  {3,1,,5,58,StrZero(Month(Date()),2)+"/"+StrZero(Year(Date()),4), 1},  {3,1,,6,57,Space(10),1},  {3,1,"Dar_Val",8,60,Space(7),4},  {3,1,"Dar_Val",9,60,Space(7),4},  {3,1,"Dar_Val",10,60,Space(7),4},  {3,1,"Dar_Val",11,60,Space(7),4},  {3,1,,13,60,Space(7),4},  {8,1,,15,44,"Imprimir",1},  {8,1,,15,58,"Cancelar",2}}
Private _ServSel:=4, _ServLista:={"1864 - ADICIONAL DE IMPOSTO DE RENDA", "2119 - ATOS DA ADMINISTRACAO GERAL", "2127 - ATOS DA SAUDE PUBLICA", "2135 - ATOS DA SEGURANCA PUBLICA", "3158 - TAXA DE FISCALIZ. DE PROJ. E CONSTRUCOES", "3166 - ATOS DA SECRETARIA DA AGRICULTURA", "3190 - TAXA JUDICIARIA", "5614 - MULTA TRANS. OU REG. DE VEIC. FORA PRAZO", "5711 - NOTAS FISCAIS", "9970 - JUNTA MEDICA"},;
        _DarAj:="Documento de Arrecada‡„o Estadual - DAR 19;;Esta janela serve para definir o conte£do  dos  campos  que;ser„o impressos no Documento de Arrecada‡„o Estadual Modelo;19.;;Para isso, preencha os campos e acione o bot„o [Imprimir]."
*
_AjTexto:=_DarAj
Whil .t.
    If Formulario(_FDar)==22
        Dar_Impres( {_FDar[4,6],_FDar[5,6],_FDar[6,6],_FDar[7,6],_FDar[8,6],_FDar[9,6],_FDar[10,6],_FDar[11,6],_FDar[12,6],_FDar[13,6],_FDar[14,6],_FDar[15,6],_FDar[16,6],_FDar[17,6],_FDar[18,6],_FDar[19,6],_FDar[20,6],_FDar[21,6]} )
    else
        Exit
    end
end
Release _ServSel, _ServLista, _DarAj
Return(0)

*
*  Gera o Total dos campos Principal, Multa, Juros e Corr.Monet.
*
Function Dar_Val(_Cod)
If _Cod==2 .or. _Cod==3
    _FObjeto[21,6]:=Val(_FObjeto[17,6])+Val(_FObjeto[18,6])+Val(_FObjeto[19,6])+Val(_FObjeto[20,6])
    _FObjeto[21,6]:=Str(_FObjeto[21,6],7)
    Form_Obj({21})
end
Return(0)

*
*  Altera o Cliente
*
Function Dar_Cli(_Cod)
Local _DarTemp
If _Cod==1 .and. _FTecla==-4
    CliControl()
    If _BDClient[7]<>0
        _DarTemp:=BDRegistro(_BDClient)
        _FObjeto[4,6]:=_DarTemp[1]
        _FObjeto[5,6]:=_DarTemp[5]
        _FObjeto[14,6]:=_DarTemp[9]
        Form_Obj({4,5,14})
        _FormAcao:=4
    end
    _AjTexto:=_DarAj
end
Return(0)

*
*  Lista com Servicos Solicitados e Codigo do Tributo
*
Function Dar_Serv(_Cod)
Local _FServ:={{,5,21,17,56,"C¢digos e Descri‡”es de Tributos para o Dar 19",_CorAtenc},  {6,1,"FormPadrao",2,3,11,50,_ServSel,_ServLista,0}, {8,1,,15,25,"Selecionar",1}, {8,1,,15,41,"Cancelar",2}}
If _Cod==1 .and. _FTecla==-4
    _AjTexto:="C¢digos e Descri‡”es de Tributos para o Dar 19;;Nesta janela, selecione um item da lista para ser  impresso;no Documento de Arrecada‡„o Estadual. Os elementos da lista;representam os C¢digos de Tributos aceit veis no Dar 19."
    If Formulario(_FServ)==3
        _ServSel:=_FServ[2,8]
        _FObjeto[7,6]:=SubStr(_ServLista[_ServSel]+Space(40),8,40)
        _FObjeto[12,6]:=SubStr(_ServLista[_ServSel],1,4)
        Form_Obj({7,12})
        _FormAcao:=4
    end
    _AjTexto:=_DarAj
end
Return(0)

*
*  Impressao do DAR 19
*
Function Dar_Impres(_DCampos)
Local _DJan:=FormMens(,"Aguarde. Imprimindo DAR 19 ...", _CorNormal, 0),;
      _DImp:=FOpen(_ImpLpt, 1), _DRet:=0, _DEnter:=Chr(13)+Chr(10)
*
Whil .t.
    If FWrite(_DImp, Chr(27)+Chr(64)+Chr(7)+Chr(27)+Chr(67)+Chr(24)+Chr(27)+Chr(51)+Chr(30)+Chr(27)+Chr(108)+Chr(0)+Chr(27)+Chr(81)+Chr(0)+Chr(27)+Chr(120)+Chr(_ImpQualid)+Chr(27)+Chr(107)+Chr(_ImpFonte)+Chr(27)+Chr(_ImpCpi)+Chr(27)+Chr(69)+Chr(27)+Chr(71))==0
        exit
    end
    If FWrite(_DImp, Space(3)+_DCampos[1]+Space(30)+_DCampos[9]+_DEnter+_DEnter+;
        Space(63)+Form_Obj3B(_DCampos[10],5)+_DEnter+;
        Space(3)+SubStr(_DCampos[2],1,3)+Space(5)+SubStr(_DCampos[2],4,3)+"-"+SubStr(_DCampos[2],7,4)+Space(5)+_DCampos[3]+_DEnter+;
        Space(63)+Form_Obj3B(_DCampos[11],7)+_DEnter+_DEnter+;
        Space(3)+_DCampos[4]+Space(20)+_DCampos[12]+_DEnter+_DEnter+;
        Space(63)+_DCampos[13]+_DEnter+;
        Space(63)+Form_Obj3B(_DCampos[14],4)+_DEnter+_DEnter+;
        Space(63)+Form_Obj3B(_DCampos[15],4)+_DEnter+_DEnter+;
        Space(63)+Form_Obj3B(_DCampos[16],4)+_DEnter+_DEnter+;
        Space(63)+Form_Obj3B(_DCampos[17],4)+_DEnter+_DEnter+;
        Space(63)+Form_Obj3B(_DCampos[18],4)+_DEnter+_DEnter+;
        Space(3)+_DCampos[5]+_DEnter+;
        Space(3)+_DCampos[6]+_DEnter+;
        Space(3)+_DCampos[7]+_DEnter+;
        Space(3)+_DCampos[8])==0
        exit
    end
    *
    _DRet:=FWrite(_DImp, Chr(27)+Chr(69)+Chr(27)+Chr(71)+Chr(12))
    exit
end
*
If _DRet==0
    FormMens("Impress„o do DAR 19","Houve um erro ao imprimir;o DAR 19 !!", _CorAtenc, 1)
end
*
FClose(_DImp)
RestScreen(_DJan[1], _DJan[2], _DJan[3], _DJan[4], _DJan[5])
Return(0)

*****************************************************************************
*****************************************************************************
***
***  Controle de Clientes
***
Function CliControl
Local _RCliManip
Whil .t.
_AjTexto:=""
_RCliManip:=Formulario({{,3,17,19,44,"Controle de CLIENTES",_CorNormal},  {6,If(Len(_BDClient[8])>0,1,0),"Cli_AltSel",2,3,11,38,_BDClient[7],_BDClient[8],0},  {8,If(Len(_BDClient[8])>=4000,0,1),,15,3,"Incluir",0},  {8,If(Len(_BDClient[8])>0,1,0),,15,16,"Consultar",0},  {8,If(Len(_BDClient[8])>0,1,0),,15,31,"Alterar",1},  {8,If(Len(_BDClient[8])>0,1,0),,17,3,"Excluir",0},  {8,If(Len(_BDClient[8])>0,1,0),,17,16,"Relat¢rio",0},  {8,1,,17,31,"Fechar",2}})
    If _RCliManip==3
        Cli_Inc()
    ElseIf _RCliManip==4
        Cli_Con()
    ElseIf _RCliManip==5
        Cli_Alt()
    ElseIf _RCliManip==6
        BDExcluir(1, @_BDClient)
    ElseIf _RCliManip==7
        Cli_Imp()
    ElseIf _RCliManip==8
        BDSalvar(_BDClient)
        Exit
    end
end
Return(0)

*
*  Atualiza o elemento selecionado na Lista
*
Function Cli_AltSel(_Cod)
If _Cod==1
    If _FTecla==22 .or. _FTecla==7
        _FormAcao:=9
        __KeyBoard(Chr(32))
        _FOAtual:=If(_FTecla==22, 3, If(_FTecla==7, 6, 0))
    end
ElseIf _Cod==2
    _BDClient[7]:=_FObjeto[2,8]
end
Return(0)

*****************************************************************************
*
*  Inclusao de Cliente
*
Function Cli_Inc
Local _FCliInc:={{,3,10,18,59,"Inclus„o de CLIENTE",_CorNormal},  {1,1,,2,2,_BDClient[4,1,1]+";"+_BDClient[4,2,1]+";"+_BDClient[4,3,1]+";"+_BDClient[4,4,1]+Space(29)+_BDClient[4,5,1]+";"+_BDClient[4,6,1]+Space(33)+",;;"+_BDClient[4,8,1]+Space(26)+_BDClient[4,9,1]+";;"+_BDClient[4,10,1]+";"+_BDClient[4,11,1]+";"+_BDClient[4,12,1]+";"+_BDClient[4,13,1]+";"+_BDClient[4,14,1],0},;
                 {3,1,"Cli_IncBt",2,7,Space(_BDClient[4,1,3]),_BDClient[4,1,4]},  {3,1,"Cli_IncBt",3,17,Space(_BDClient[4,2,3]),_BDClient[4,2,4]},  {3,1,,4,6,Space(_BDClient[4,3,3]),_BDClient[4,3,4]},  {3,1,,5,9,Space(_BDClient[4,4,3]),_BDClient[4,4,4]},  {3,1,,5,42,Space(_BDClient[4,5,3]),_BDClient[4,5,4]},  {3,1,,6,9,Space(_BDClient[4,6,3]),_BDClient[4,6,4]},  {3,1,,6,43,Space(_BDClient[4,7,3]),_BDClient[4,7,4]},  {3,1,"Cli_IncBt",8,13,Space(_BDClient[4,8,3]),_BDClient[4,8,4]},  {3,1,"Cli_IncBt",8,42,Space(_BDClient[4,9,3]),_BDClient[4,9,4]},  {3,1,,10,22,Space(_BDClient[4,10,3]),_BDClient[4,10,4]},  {3,1,,11,22,Space(_BDClient[4,11,3]),_BDClient[4,11,4]},  {3,1,,12,22,Space(_BDClient[4,12,3]),_BDClient[4,12,4]},  {3,1,,13,22,Space(_BDClient[4,13,3]),_BDClient[4,13,4]},  {3,1,,14,22,Space(_BDClient[4,14,3]),_BDClient[4,14,4]},  {8,0,,16,30,"Incluir",1},  {8,1,,16,43,"Cancelar",2}}
Whil .t.
    _AjTexto:=""
    If Formulario(_FCliInc)==17
        _AjTexto:=""
        _BDClient[7]:=1
        If BDConsult(0, @_BDClient, {_FCliInc[3,6],1,1}, {_FCliInc[4,6],2,1})<>0
            FormMens("Inclus„o de CLIENTES","Estas Informa‡”es j  foram;encontradas no Banco de Dados !;;Imposs¡vel reinclu¡-las.",_CorAtenc,1)
            Loop
        end
        BDAtualiz(1, _BDClient, _FCliInc[3,6]+_FCliInc[4,6]+_FCliInc[5,6]+_FCliInc[6,6]+_FCliInc[7,6]+_FCliInc[8,6]+_FCliInc[9,6]+_FCliInc[10,6]+_FCliInc[11,6]+_FCliInc[12,6]+_FCliInc[13,6]+_FCliInc[14,6]+_FCliInc[15,6]+_FCliInc[16,6], 0)
    end
    Exit
end
Return(0)

*
*  Habilita/Desabilita botao de Inclusao
*
Function Cli_IncBt(_Cod)
If _Cod==2 .or. _Cod==3
    _FObjeto[17,2]:=If(_FObjeto[3,6]<>Space(_BDClient[4,1,3]) .and. _FObjeto[4,6]<>Space(_BDClient[4,2,3]) .and. _FObjeto[10,6]<>Space(_BDClient[4,8,3]) .and. _FObjeto[11,6]<>Space(_BDClient[4,9,3]),1,0)
    Form_Obj({17})
end
Return(0)

*****************************************************************************
*
*  Consulta de Cliente
*
Function Cli_Con()
Local _Campos:={1,2,5,6,8,9}, _FCliCon:={{,5,10,14,59,"Consulta de CLIENTE",_CorNormal},{5,1,"Cli_ConOp",2,3,1,{_BDClient[4,1,1],_BDClient[4,2,1],_BDClient[4,5,1],_BDClient[4,6,1],_BDClient[4,8,1],_BDClient[4,9,1]}},  {3,1,,2,20,Space(_BDClient[4,1,3]),_BDClient[4,1,4]},  {3,0,,3,23,Space(_BDClient[4,2,3]),_BDClient[4,2,4]},  {3,0,,4,20,Space(_BDClient[4,5,3]),_BDClient[4,5,4]},  {3,0,,5,20,Space(_BDClient[4,6,3]),_BDClient[4,6,4]},  {3,0,,6,20,Space(_BDClient[4,8,3]),_BDClient[4,8,4]},  {3,0,,7,20,Space(_BDClient[4,9,3]),_BDClient[4,9,4]},  {4,1,,9,3,0,"Consulta Exata"},  {4,1,,10,3,0,"Consulta desde o In¡cio"},  {8,1,,12,28,"Consultar",1},  {8,1,,12,43,"Cancelar",2}}
_AjTexto:=""
If Formulario(_FCliCon)==11
    If _FCliCon[10,6]==1
        _BDClient[7]:=1
    end
    BDConsult(1, @_BDClient, {_FCliCon[2+_FCliCon[2,6],6],_Campos[_FCliCon[2,6]],_FCliCon[9,6]})
end
Return(0)

*
*  Auxilio a funcao Cli_Con
*  (Alterna o campo selecionado a ser feita a Consulta)
*
Function Cli_ConOp(_Cod)
If _Cod==2
    _FObjeto[8,2]:=_FObjeto[7,2]:=_FObjeto[6,2]:=_FObjeto[5,2]:=_FObjeto[4,2]:=_FObjeto[3,2]:=0
    _FObjeto[_FObjeto[2,6]+2, 2]:=1
    Form_Obj({3,4,5,6,7,8})
end
Return(0)

*****************************************************************************
*
*  Alteracao de Cliente
*
Function Cli_Alt
Local _FCliAlt
Private _CAlter:=BDRegistro(_BDClient)
_FCliAlt:={{,3,10,18,59,"Altera‡„o de CLIENTE",_CorNormal},  {1,1,,2,2,_BDClient[4,1,1]+";"+_BDClient[4,2,1]+";"+_BDClient[4,3,1]+";"+_BDClient[4,4,1]+Space(29)+_BDClient[4,5,1]+";"+_BDClient[4,6,1]+Space(33)+",;;"+_BDClient[4,8,1]+Space(26)+_BDClient[4,9,1]+";;"+_BDClient[4,10,1]+";"+_BDClient[4,11,1]+";"+_BDClient[4,12,1]+";"+_BDClient[4,13,1]+";"+_BDClient[4,14,1],0},;
           {1,1,,2,7,_CAlter[1],0},  {1,1,,3,17,Form_Obj3B(_CAlter[2],_BDClient[4,2,4]),0},  {3,1,"Cli_AltSlv",4,6,_CAlter[3],_BDClient[4,3,4]},  {3,1,"Cli_AltSlv",5,9,_CAlter[4],_BDClient[4,4,4]},  {3,1,"Cli_AltSlv",5,42,_CAlter[5],_BDClient[4,5,4]},  {3,1,"Cli_AltSlv",6,9,_CAlter[6],_BDClient[4,6,4]},  {3,1,"Cli_AltSlv",6,43,_CAlter[7],_BDClient[4,7,4]},  {3,1,"Cli_AltSlv",8,13,_CAlter[8],_BDClient[4,8,4]},  {3,1,"Cli_AltSlv",8,42,_CAlter[9],_BDClient[4,9,4]},  {3,1,"Cli_AltSlv",10,22,_CAlter[10],_BDClient[4,10,4]},  {3,1,"Cli_AltSlv",11,22,_CAlter[11],_BDClient[4,11,4]},  {3,1,"Cli_AltSlv",12,22,_CAlter[12],_BDClient[4,12,4]},  {3,1,"Cli_AltSlv",13,22,_CAlter[13],_BDClient[4,13,4]},  {3,1,"Cli_AltSlv",14,22,_CAlter[14],_BDClient[4,14,4]},  {8,0,,16,31,"Salvar",1},  {8,1,,16,43,"Cancelar",2}}
Whil .t.
    _AjTexto:=""
    If Formulario(_FCliAlt)==17
        BDAtualiz(1, _BDClient, _CAlter[1]+_CAlter[2]+_FCliAlt[5,6]+_FCliAlt[6,6]+_FCliAlt[7,6]+_FCliAlt[8,6]+_FCliAlt[9,6]+_FCliAlt[10,6]+_FCliAlt[11,6]+_FCliAlt[12,6]+_FCliAlt[13,6]+_FCliAlt[14,6]+_FCliAlt[15,6]+_FCliAlt[16,6], 1)
    end
    Exit
end
Release _CAlter
Return(0)

*
*  Habilita/Desabilita Botao Salvar
*
Function Cli_AltSlv(_Cod)
If _Cod==2 .or. _Cod==3
    _FObjeto[17,2]:=If(_FObjeto[5,6]<>_CAlter[3] .or. _FObjeto[6,6]<>_CAlter[4] .or. _FObjeto[7,6]<>_CAlter[5] .or. _FObjeto[8,6]<>_CAlter[6] .or. _FObjeto[9,6]<>_CAlter[7] .or. _FObjeto[10,6]<>_CAlter[8] .or. _FObjeto[11,6]<>_CAlter[9] .or. _FObjeto[12,6]<>_CAlter[10] .or. _FObjeto[13,6]<>_CAlter[11] .or. _FObjeto[14,6]<>_CAlter[12] .or. _FObjeto[15,6]<>_CAlter[13] .or. _FObjeto[16,6]<>_CAlter[14] ,1,0)
    Form_Obj({17})
end
Return(0)

*****************************************************************************
*
*  Relatorio de Clientes
*
Function Cli_Imp
Local _CCont:=BDRegistro(_BDClient), _CTabela:={},;
      _FCliImp:={{,8,17,10,45,"Conte£do do Relat¢rio",_CorNormal}, {1,1,,2,3,"Determine o Conte£do do Relat¢rio:",0}, {5,1,"Cli_ImpRel",4,3,1,{"Todos os Clientes","Informa‡”es do Cliente Selecionado"}}, {1,0,,6,8,"",0}, {8,1,,8,15,"Continuar",1}, {8,1,,8,30,"Cancelar",2}}
*
_FCliImp[4,6]:=_CCont[1]
If Formulario(_FCliImp)==6
    Return(0)
end
*
If _FCliImp[3,6]==1
    For _CCont:=1 to Len(_BDClient[8])
        AAdd(_CTabela,;
            SubStr(_BDClient[8,_CCont],1,35) +Space(2)+;
            Form_Obj3B(SubStr(_BDClient[8,_CCont],172,8) ,5) +Space(2)+;
            Form_Obj3B(SubStr(_BDClient[8,_CCont],180,8) ,5) +Space(2)+;
            SubStr(_BDClient[8,_CCont],188,12)  +Space(2)+;
            Form_Obj3B(SubStr(_BDClient[8,_CCont],200,8) ,5))
    next
    _CCont:={"Nome"+Space(33)+"1a. Habil."+Space(2)+"Expedicao"+Space(3)+"Registro"+Space(6)+"Validade"+Space(2), "cliente(s)"}
else
    AAdd(_CTabela, "Nome ................. "+_CCont[1] +Chr(13)+Chr(10)+;
    "Data de Nascimento ... "+Form_Obj3B(_CCont[2],5) +Chr(13)+Chr(10)+;
    "Rua .................. "+_CCont[3] +Chr(13)+Chr(10)+;
    "Numero ............... "+_CCont[4] +Chr(13)+Chr(10)+;
    "Fone ................. "+Form_Obj3B(_CCont[5],6) +Chr(13)+Chr(10)+;
    "Cidade ............... "+_CCont[6] +Chr(13)+Chr(10)+;
    "Uf ................... "+_CCont[7] +Chr(13)+Chr(10)+;
    "Identidade ........... "+_CCont[8] +Chr(13)+Chr(10)+;
    "Cpf .................. "+Form_Obj3B(_CCont[9],7) +Chr(13)+Chr(10)+;
    "Categoria ............ "+_CCont[10] +Chr(13)+Chr(10)+;
    "Data 1a Habilitacao .. "+Form_Obj3B(_CCont[11],5) +Chr(13)+Chr(10)+;
    "Data Expedicao ....... "+Form_Obj3B(_CCont[12],5) +Chr(13)+Chr(10)+;
    "Numero do Registro ... "+_CCont[13] +Chr(13)+Chr(10)+;
    "Validade ............. "+Form_Obj3B(_CCont[14],5))
    _CCont:={"Informacoes Pessoais","cliente"}
end
*
BDRelator(_CTabela, {1, _SisDescr, 1, _SisLicen, 1, 1, 1, _CCont[1], _CCont[2]})
Return(0)

*
*  Mostrar Nome do Cliente Selecionado
*
Function Cli_ImpRel(_Cod)
If _Cod==2
    _FObjeto[4,2]:=_FObjeto[3,6]-1
    Form_Obj({4})
end
Return(0)
/*
              Controle
              0123456789 123456789 123456789 123456789 1234567 0
              1                                                1
              2  /------------------------------------------\  2
              3  I                                          I  3
              4  I                                          I  4
              5  I                                          I  5
              6  I                                          I  6
              7  I                                          I  7
              8  I                                          I  8
              9  I                                          I  9
             10  I                                          I  10
             11  I                                          I  11
             12  I                                          I  12
             13  \------------------------------------------/  13
             14                                                14
             15    [ Incluir ]  [ Consultar ]  [ Alterar ]     15
             16                                                16
             17    [ Excluir ]  [ Relatorio ]  [ Fechar ]      17
             18                                                18
             19 23456789 123456789 123456789 123456789 1234567 19

         Inclusao
         0123456789 123456789 123456789 123456789 123456789 1234567 0
         1                                                          1
         2 Nome [35                                 ]               2
         3 Data de Nascimento [10        ]                          3
         4 Rua [50                                                ] 4
         5 Numero [12345]                     Fone [14            ] 5
         6 Cidade [30                            ], [2 ]            6
         7                                                          7
         8 Identidade [14            ]         Cpf [14            ] 8
         9                                                          9
        10 Categoria           [6     ]                             10
        11 Data 1§ Habilitacao [10        ]                         11
        12 Data Expedicao      [10        ]                         12
        13 Num. do Registro    [12          ]                       13
        14 Validade            [10        ]                         14
        15                                                          15
        16                             [ Incluir ]  [ Cancelar ]    16
        17                                                          17
        18 23456789 123456789 123456789 123456789 123456789 1234567 18

           Consulta
           0123456789 123456789 123456789 123456789 123456789 123 0
           1                                                      1
           2  > Nome       [35                                 ]  2
           3  o Data de Nasc. [10        ]                        3
           4  o Fone       [14            ]                       4
           5  o Cidade     [30                            ]       5
           6  o Identidade [14            ]                       6
           7  o Cpf        [14            ]                       7
           8                                                      8
           9  x Consulta Exata                                    9
          10  x Consulta desde o Inicio                           10
          11                                                      11
          12                       [ Consultar ]  [ Cancelar ]    12
          13                                                      13
          14 23456789 123456789 123456789 123456789 123456789 123 14

                Conteudo do Relatorio
                0123456789 123456789 123456789 123456789 123 0
                1                                            1
                2  Determine o Conteudo do Relatorio:        2
                3                                            3
                4  [() Todos os Clientes                    4
                5  [( ) Informacoes do Cliente Selecionado   5
                6       Paulo Sergio Klaus.................  6
                7                                            7
                8              [ Continuar ]  [ Cancelar ]   8
                9                                            9
               10 23456789 123456789 123456789 123456789 123 10

==============
Banco de Dados
==============
35 Nome
 8 Data de Nasc
50 Rua
 5 N£mero
10 Fone
30 Cidade
 2 Uf
14 Identidade
11 Cpf
 6 Categoria
 8 Data 1¦ Habilita‡„o
 8 Data Expedi‡„o
12 N£m. do Registro
 8 Validade
-----------
207 bytes por registro
*/

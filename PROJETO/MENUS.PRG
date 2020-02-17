*****************************************************************************
*****************************************************************************
***
***   Controle Avancado de Menus em Clipper 5.3
***   Paulo Sergio Klaus
***   MENUS.PRG
***
*****************************************************************************
*****************************************************************************
*
*  Inicia um Menu Padronizado
*
*  _SParam1=Menu
*  _SLocal1=Menu selecionado
*  _SLocal2=Menu selecionado temporario (para verificar alteracao de menu)
*  _SLocal3=Item selecionado temporario (para verificar alteracao de item)
*  _SLocal4=Funcao do item selecionado a ser executada
*  _SLocal5=Tela de Fundo do Menu
*
Function SuperMenu()
Local _SLocal1:=1, _SLocal2:=2, _SLocal3:=0, _SLocal4:="", _SLocal5
Private _STecla:=0, _SMenuAcao:=0
*
SetColor(_CorNormal)
ColorSelect(0)
Scroll(1,0,1,79)
_SisMenu:=SCalcMenus()
MPresent(.t.)
*
Whil .t.
    If _SLocal1<>_SLocal2
        RestScreen(_SisMenu[_SLocal2,4], _SisMenu[_SLocal2,5], _SisMenu[_SLocal2,6], _SisMenu[_SLocal2,7], _SLocal5)
        _SLocal5:=SaveScreen(_SisMenu[_SLocal1,4], _SisMenu[_SLocal1,5], _SisMenu[_SLocal1,6], _SisMenu[_SLocal1,7])
        SMenuConst(_SLocal1)
        _SLocal2:=_SLocal1
    end
    If _SLocal3<>_SisMenu[_SLocal1,8]
        SItemConst(_SisMenu[_SLocal1])
        _SLocal3:=_SisMenu[_SLocal1,8]
    end
    *
    SMenuTecla()
    *
    If _SMenuAcao==0
        _SLocal1:=SMenuScan(_SLocal1)
        If _SLocal1<>_SLocal2 .or. _SLocal3<>_SisMenu[_SLocal1,8]
            __KeyBoard(Chr(32))
            Loop
        end
    end
    *
    If _SMenuAcao==1
        _SLocal1:=If(_SLocal1==1, Len(_SisMenu), _SLocal1-1)
    ElseIf _SMenuAcao==2
        _SLocal1:=If(_SLocal1==Len(_SisMenu), 1, _SLocal1+1)
    ElseIf _SMenuAcao==3 .or. _SMenuAcao==4
        Whil .t.
            If _SMenuAcao==3
                _SisMenu[_SLocal1,8]:=If(_SisMenu[_SLocal1,8]==1, Len(_SisMenu[_SLocal1,9]), _SisMenu[_SLocal1,8]-1)
            else
                _SisMenu[_SLocal1,8]:=If(_SisMenu[_SLocal1,8]==Len(_SisMenu[_SLocal1,9]), 1, _SisMenu[_SLocal1,8]+1)
            end
            *
            If _SisMenu[_SLocal1,9,_SisMenu[_SLocal1,8],1]==2
                Loop
            end
            Exit
        end
    ElseIf _SMenuAcao==5
        _SisMenu[_SLocal1,8]:=If(_SisMenu[_SLocal1,9,1,1]==2,2,1)
    ElseIf _SMenuAcao==6
        _SisMenu[_SLocal1,8]:=Len(_SisMenu[_SLocal1,9])
    ElseIf _SMenuAcao==7
        SItemEfeit(_SisMenu[_SLocal1])
        RestScreen(_SisMenu[_SLocal2,4], _SisMenu[_SLocal2,5], _SisMenu[_SLocal2,6], _SisMenu[_SLocal2,7], _SLocal5)
        *
        * Executa funcao
        _SLocal4:=_SisMenu[_SLocal1,9,_SisMenu[_SLocal1,8],4]
        If _SLocal4<>Nil
            &_SLocal4()
        end
        _SLocal4:=""
        *
        _SLocal5:=SaveScreen(_SisMenu[_SLocal1,4], _SisMenu[_SLocal1,5], _SisMenu[_SLocal1,6], _SisMenu[_SLocal1,7])
        SMenuConst(_SLocal1)
        _SLocal2:=_SLocal1
    end
    If _SMenuAcao==8
        Exit
    end
    _SMenuAcao:=0
end
Return(0)

*****************************************************************************
*
*  Calcula a posicao dos Menus
*
*  _SLocal1=Contador
*  _SLocal2=Contador de Itens (descobre o tamanho do maior item do menu para calcular o tamanho em colunas do menu)
*  _SLocal3=Posicao do Proximo Menu (conta automaticamente a posicao do proximo titulo do menu)
*
Function SCalcMenus
Local _SLocal1, _SLocal2, _SLocal3:=1
For _SLocal1:=1 to Len(_SisMenu)
    _SisMenu[_SLocal1,1]:=If(_SisMenu[_SLocal1,1]==Nil .or. _SisMenu[_SLocal1,1]==0, 1, _SisMenu[_SLocal1,1])
    _SisMenu[_SLocal1,2]:=If(_SisMenu[_SLocal1,2]==Nil .or. _SisMenu[_SLocal1,2]==0, _SLocal3, _SisMenu[_SLocal1,2])
    _SisMenu[_SLocal1,4]:=If(_SisMenu[_SLocal1,4]==Nil .or. _SisMenu[_SLocal1,4]==0, _SisMenu[_SLocal1,1]+1, _SisMenu[_SLocal1,4])
    _SisMenu[_SLocal1,5]:=If(_SisMenu[_SLocal1,5]==Nil .or. _SisMenu[_SLocal1,5]==0, _SisMenu[_SLocal1,2], _SisMenu[_SLocal1,5])
    _SisMenu[_SLocal1,6]:=If(_SisMenu[_SLocal1,6]==Nil .or. _SisMenu[_SLocal1,6]==0, _SisMenu[_SLocal1,1]+2+Len(_SisMenu[_SLocal1,9]), _SisMenu[_SLocal1,6])
    For _SLocal2:=1 to Len(_SisMenu[_SLocal1,9])
        _SisMenu[_SLocal1,7]:=If(_SisMenu[_SLocal1,7]<Len(_SisMenu[_SLocal1,9,_SLocal2,2]), Len(_SisMenu[_SLocal1,9,_SLocal2,2]), _SisMenu[_SLocal1,7])
    next
    _SisMenu[_SLocal1,7]:=_SisMenu[_SLocal1,5]+_SisMenu[_SLocal1,7]+3
    _SisMenu[_SLocal1,8]:=If(_SisMenu[_SLocal1,8]==Nil .or. _SisMenu[_SLocal1,8]==0, 1, _SisMenu[_SLocal1,8])
    _SLocal3+=Len(_SisMenu[_SLocal1,3])+2
next
Return(_SisMenu)

*****************************************************************************
*
*  Constroe a barra de Menu
*
*  _SParam1=Numero do Menu Selecionado
*  _SLocal1=Contador
*
Function SMenuConst(_SParam1)
Local _SLocal1
For _SLocal1:=1 to Len(_SisMenu)
    ColorSelect( If(_SLocal1==_SParam1,1,0) )
    SetPos(_SisMenu[_SLocal1,1], _SisMenu[_SLocal1,2]); DispOut( Chr(32)+_SisMenu[_SLocal1,3]+Chr(32) )
next
ColorSelect(0)
DispBox(_SisMenu[_SParam1,4], _SisMenu[_SParam1,5], _SisMenu[_SParam1,6], _SisMenu[_SParam1,7], "ÚÄ¿³ÙÄÀ³ ")
SItemConst(_SisMenu[_SParam1])
Return(0)

*****************************************************************************
*
*  Constroe as opcoes de Formulario
*
*  _SParam1=Propriedades do Menu Selecionado
*  _SLocal1=Contador
*  _SLocal2=Texto do Item temporariamente selecionado
*
Function SItemConst(_SParam1)
Local _SLocal1, _SLocal2:=""
For _SLocal1:=1 to Len(_SParam1[9])
    ColorSelect( If(_SParam1[8]==_SLocal1,1,0) )
    SetPos(_SParam1[4]+_SLocal1, _SParam1[5]+1)
    _SLocal2:=If( _SParam1[9,_SLocal1,1]==0 .or. _SParam1[9,_SLocal1,1]==1, _SParam1[9,_SLocal1,2]+Space(_SParam1[7]), Repl(Chr(196), _SParam1[7]) )
    _SLocal2:=SubStr(_SLocal2, 1, _SParam1[7]-_SParam1[5]-3)
    DispOut( Chr(If(_SParam1[9,_SLocal1,1]==0, 32, If(_SParam1[9,_SLocal1,1]==1, 120, 196)))   +   _SLocal2   +   Chr(If(_SParam1[9,_SLocal1,1]==0 .or. _SParam1[9,_SLocal1,1]==1, 32, 196)) )
next
ColorSelect(0)
_SLocal2:=If(_SParam1[9,_SParam1[8],5]<>Nil, _SParam1[9,_SParam1[8],5], Space(1))+Space(47)
SetPos(24,13);DispOut( SubStr(_SLocal2,1,47) )
Return(0)

*****************************************************************************
*
*  Efeito de Selecao
*
Function SItemEfeit(_SParam1)
Local  _SLocal1, _SLocal2:=If( _SParam1[9,_SParam1[8],1]==0 .or. _SParam1[9,_SParam1[8],1]==1, _SParam1[9,_SParam1[8],2]+Space(_SParam1[7]), Repl(Chr(196), _SParam1[7]) )
_SLocal2:=SubStr(_SLocal2, 1, _SParam1[7]-_SParam1[5]-3)
_SLocal2:=Chr(If(_SParam1[9,_SParam1[8],1]==0, 32, If(_SParam1[9,_SParam1[8],1]==1, 229, 205)))   +   _SLocal2   +   Chr(If(_SParam1[9,_SParam1[8],1]==0 .or. _SParam1[9,_SParam1[8],1]==1, 32, 205))
*
For _SLocal1:=0 to 4
    ColorSelect( If(Int(_SLocal1/2)-_SLocal1/2==0,0,1) )
    SetPos(_SParam1[4]+_SParam1[8], _SParam1[5]+1)
    DispOut(_SLocal2)
    Inkey(0.02)
next
Return(0)

*****************************************************************************
*
*  Construcao da tabela das Teclas de Atalho
*
Function SMenuScan(_SParam1)
Local _SLocal1, _SLocal2
For _SLocal1:=1 to Len(_SisMenu)
    For _SLocal2:=1 to Len(_SisMenu[_SLocal1,9])
        If _SisMenu[_SLocal1,9,_SLocal2,3]==_STecla
            _SisMenu[_SLocal1,8]:=_SLocal2
            _SMenuAcao:=7
            Return(_SLocal1)
        end
    next
next
Return(_SParam1)

*****************************************************************************
*
*  Controle de Teclas
*
Function SMenuTecla()
Whil .t.
    If _SisHora[1]<>Time()
        SetColor(_CorNormal)
        _SisHora:={Time(), If(_SisHora[2]==2,1,2)}
        SetPos(24, 1);DispOut( Time()+Chr(If(_SisHora[2]==1,7,9)) )
    end
    _STecla:=Inkey(,128)
    If _STecla==-47
        _STecla:={SaveScreen(0,0,24,79), SetColor()}
        SetColor("00/00,00/00,00")
        Scroll();SetPos(12,40)
        Whil Inkey(0)<>-47
            Tone(20000, 0.1)
        end
        RestScreen(0,0,24,79,_STecla[1])
        SetColor(_STecla[2])
        _STecla:=0
    ElseIf _STecla<>0
        Exit
    end
end
*
SetColor(_CorNormal)
_SMenuAcao:=If(_STecla==19, 1, If(_STecla==4, 2, If(_STecla==5, 3, If(_STecla==24, 4, If(_STecla==1, 5, If(_STecla==6, 6, If(_STecla==13, 7, _SMenuAcao)))))))
Return(0)

/*
Est ..... 0=Normal, 1=Selecionado, 2=Tracado)
Item .... Titulo
Atalho .. Codigo da Tecla de Atalho
Funcao .. Funcao a ser executada ao acionar este item
Mens .... Mensagem para aparecer na barra de mensagens

_SisMenu:=
{
{X, Y, MenuA, X1, Y1, X2, Y2, Sel, {{Est1A, Item1A, Atalho1A, Funcao1A, Mens1A}, {Est2A, Item2A, Atalho2A, Funcao2A, Mens2A}} },;
{X, Y, MenuB, X1, Y1, X2, Y2, Sel, {{Est1B, Item1B, Atalho1B, Funcao1B, Mens1B}, {Est2B, Item2B, Atalho2B, Funcao2B, Mens2B}} },;
}

1 -Menu .......... 19
2 +Menu .......... 4
3 -Item .......... 5
4 +Item .......... 24
5 Primeiro Item .. 1
6 Ultimo Item .... 6
7 Executar Item .. 13
8 Encerrar Menu
*/

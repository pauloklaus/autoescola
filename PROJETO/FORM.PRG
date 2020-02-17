*****************************************************************************
*****************************************************************************
***
***   Controle Avancado de Formulario em Clipper 5.3
***   Paulo Sergio Klaus
***   FORM.PRG
***
*****************************************************************************
*****************************************************************************
***
***   CONTROLE DE FORMULARIOS
***
*****************************************************************************
*****************************************************************************
*
*****************************************************************************
*
*   Objetos que esta funcao suporta:
*
*   -> Janela (* Deve ser sempre o primeiro objeto)
*     {Funcao, Lin, Col, TamLin, TamCol, Titulo, Cor}
*
*   -> Apresentacao de Textos
*      {1, Estado, Funcao, Lin, Col, Texto, Formato}
*                                           (0,1,2)
*
*   -> Caixa 3d
*      {2, Estado, Funcao, Lin, Col, TamLin, TamCol}
*
*   -> Caixa de Edicao de Textos
*      {3, Estado, Funcao, Lin, Col, Texto, Formato}
*                                           (0,1,2,3,4,5,6,7,8)
*
*   -> Caixa de Verificacao
*      {4, Estado, Funcao, Lin, Col, Selecao, Texto}
*
*   -> Escolha de Opcoes
*      {5, Estado, Funcao, Lin, Col, Selecao, Opcoes}
*
*   -> Lista de Elementos
*      {6, Estado, Funcao, Lin, Col, TamLin, TamCol, Selecao, Elementos, 0}
*
*   -> Controle de Cor
*      {7, Estado, Funcao, Lin, Col, Cor}
*                                    No formato "00/00" numerico
*
*   -> Botao de Ativacao
*      {8, Estado, Funcao, Lin, Col, Texto, Padrao}
*
*****************************************************************************
*
*  -> Manipulador de Formularios
*
*  _FParam1=Lista dos Objetos
*  _FLocal1=Fundo
*  _FLocal2=Cor temporaria
*  _FLocal3=Topo temporario do objeto Lista atual | Coordenadas temporarias
*
Function Formulario(_FParam1)
Local _FLocal1, _FLocal2:=SetColor(), _FLocal3
*
Private _FPFuncao:=If(_FParam1[1,1]==Nil, "FormNulo", _FParam1[1,1]),;
        _FPLin:=_FParam1[1,2], _FPCol:=_FParam1[1,3],;
        _FPTamLin:=_FParam1[1,4], _FPTamCol:=_FParam1[1,5],;
        _FPTitulo:=_FParam1[1,6], _FPCor:=_FParam1[1,7]
*
Private _FObjeto:=_FParam1, _FOAtual:=2, _FormAcao:=0,;
        _FTecla:=0, _FBotPadr:=0, _FBotFecha:=0, _FNomeObj, _FOFuncao:=""
_FParam1:=Nil
*
* Salva o fundo e imprime a Janela e os Objetos do Formulario
_FLocal1:=Form_Fundo()
SetColor(_FPCor)
Form_Jan(_FPTitulo, _FPLin, _FPCol, _FPTamLin, _FPTamCol)
Form_Obj({})
&_FPFuncao(0)
*
* Acertando objeto atual
Whil .t.
    If _FObjeto[_FOAtual, 1]<>1 .and. _FObjeto[_FOAtual, 1]<>2 .and. _FObjeto[_FOAtual, 2]<>0
        exit
    end
    _FOAtual:=If(_FOAtual==Len(_FObjeto), 2, _FOAtual+1)
end
*
* Controle
Whil .t.
    If _FormAcao==0
        _FOFuncao:=If(_FObjeto[_FOAtual,3]==Nil, "Form"+If(_FObjeto[_FOAtual,1]==8,"Fechar","Nulo"), _FObjeto[_FOAtual,3])
        &_FOFuncao(0)
        If _FObjeto[_FOAtual,1]<>6
            _FNomeObj:="Form_Obj"+Str(_FObjeto[_FOAtual,1],1)
            &_FNomeObj(_FPLin+_FObjeto[_FOAtual,4], _FPCol+_FObjeto[_FOAtual,5], _FObjeto[_FOAtual,6], _FObjeto[_FOAtual,7])
            _FNomeObj:=Nil
        else
            _FLocal3:=_FObjeto[_FOAtual,10]
            _FNomeObj:=_FOAtual  // Aproveitada a variavel _FNomeObj
            Form_Obj6(_FPLin+_FObjeto[_FOAtual,4], _FPCol+_FObjeto[_FOAtual,5], _FObjeto[_FOAtual,6], _FObjeto[_FOAtual,7], _FObjeto[_FOAtual,8], _FObjeto[_FOAtual,9], @_FLocal3)
            _FObjeto[_FNomeObj,10]:=_FLocal3
            _FNomeObj:=Nil
        end
        &_FOFuncao(3)
    end
    *
    * Acoes a serem Executadas no Formulario
    If _FormAcao==1         // Move a Janela do Formulario
        Form_Move(_FLocal1)
        *
    ElseIf _FormAcao==2     // Encerra o Formulario
        &_FPFuncao(1)
        If _FormAcao==2
            Exit
        end
        *
    ElseIf _FormAcao==3     // Objeto Anterior
        Whil .t.
            _FOAtual:=If(_FOAtual==2, Len(_FObjeto), _FOAtual-1)
            If _FObjeto[_FOAtual, 1]<>1 .and. _FObjeto[_FOAtual, 1]<>2 .and. _FObjeto[_FOAtual, 2]<>0
                exit
            end
        end
        *
    ElseIf _FormAcao==4     // Proximo Objeto
        Whil .t.
            _FOAtual:=If(_FOAtual==Len(_FObjeto), 2, _FOAtual+1)
            If _FObjeto[_FOAtual, 1]<>1 .and. _FObjeto[_FOAtual, 1]<>2 .and. _FObjeto[_FOAtual, 2]<>0
                exit
            end
        end
        *
    ElseIf _FormAcao==5     // Refresca os Objetos
        Form_Obj({})
        *
    ElseIf _FormAcao==6     // Aciona o Botao Padrao
        If _FBotPadr<>0 .and. _FObjeto[_FBotPadr,2]==1
            _FOAtual:=_FBotPadr
            __KeyBoard(Chr(32))
        end
        *
    ElseIf _FormAcao==7     // Aciona o Botao de Fechamento
        If _FBotFecha<>0 .and. _FObjeto[_FBotFecha,2]==1
            _FOAtual:=_FBotFecha
            __KeyBoard(Chr(32))
        end
        *
    end
    _FormAcao:=0
    * Fim das Acoes
    *
end
Form_Fundo(_FLocal1)
SetColor(_FLocal2)
*
Return(_FOAtual)

*****************************************************************************
*
*  -> Salva/Restaura o fundo atras da Janela do Formulario
*     Se for passado um parametro, a funcao restaura a tela atraves
*     do parametro repassado, caso contrario ela retorna a tela salva
*
*  _FParam1=Fundo
*  _FLocal1=Contador
*
Function Form_Fundo(_FParam1)
Local _FLocal1
*
_FParam1:=If(PCount()==0, {{},{}}, _FParam1)
If PCount()==0
    For _FLocal1:=2 to 23
        AAdd(_FParam1[1], SaveScreen(_FLocal1, 0, _FLocal1, 79))
    next
    For _FLocal1:=0 to 79
        AAdd(_FParam1[2], SaveScreen(2, _FLocal1, 23, _FLocal1))
    next
else
    For _FLocal1:=2 to 23
        RestScreen(_FLocal1, 0, _FLocal1, 79, _FParam1[1,_FLocal1-1])
    next
end
Return(_FParam1)

*****************************************************************************
*
*  -> Impressao da Janela do Formulario
*
*  _FParam1=Titulo
*  _FParam2=Linha Inicial
*  _FParam3=Coluna Inicial
*  _FParam4=Tamanho em Linhas
*  _FParam5=Tamanho em Colunas
*
Function Form_Jan(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5)
*
* Efeito de movimento e impressao da janela
Set(14,0) // Set Type to 0
ColorSelect(0)
DispBox( ((_FParam2+_FParam2+_FParam4)/2)-1 , ((_FParam3+_FParam3+_FParam5)/2)-2 , ((_FParam2+_FParam2+_FParam4)/2)+1 , ((_FParam3+_FParam3+_FParam5)/2)+2 , "⁄ƒø≥Ÿƒ¿≥ ")
Inkey(0.04)
DispBox( ((_FParam2+_FParam2+_FParam4)/2)-2 , ((_FParam3+_FParam3+_FParam5)/2)-4 , ((_FParam2+_FParam2+_FParam4)/2)+2 , ((_FParam3+_FParam3+_FParam5)/2)+4 , "⁄ƒø≥Ÿƒ¿≥ ")
Inkey(0.04)
DispBox(_FParam2, _FParam3, _FParam2+_FParam4, _FParam3+_FParam5, "⁄ƒø≥Ÿƒ¿≥ ")
*
* Imprime a barra de Titulo da janela
If _FParam1<>Nil
    SetPos(_FParam2, _FParam3+1);DispOut(Chr(180))
    SetPos(_FParam2, _FParam3+_FParam5-1);DispOut(Chr(195))
    ColorSelect(1)
    SetPos(_FParam2, _FParam3+2);DispOut( Chr(32)+SubStr(_FParam1+Space(_FParam5),1,_FParam5-5)+Chr(32) )
end
*
ColorSelect(0)
Set(14,1) // Set Type to 1
Return(0)

*****************************************************************************
*
*  -> Impressao dos Objetos
*
*  _FParam1=Objetos a serem refrescado (reapresentados)
*  _FLocal1=Contador
*  _FLocal2=Funcao de apresentacao do objeto a ser impresso
*
Function Form_Obj(_FParam1)
Local _FLocal1, _FLocal2
If Len(_FParam1)==0
    For _FLocal1:=2 to Len(_FObjeto)  // Comecao em 2, pois o 1o. sao as
        AAdd(_FParam1, _FLocal1)      // propriedades da janela do formulario
    next
end
*
For _FLocal1:=1 to Len(_FParam1)
    If _FObjeto[_FParam1[_FLocal1],1]<>6
        _FLocal2:="Form_CObj"+Str( _FObjeto[_FParam1[_FLocal1],1] ,1)
        &_FLocal2(0, _FObjeto[_FParam1[_FLocal1],2], _FPLin+_FObjeto[_FParam1[_FLocal1],4], _FPCol+_FObjeto[_FParam1[_FLocal1],5], _FObjeto[_FParam1[_FLocal1],6], _FObjeto[_FParam1[_FLocal1],7])
        _FLocal2:=Nil
        If _FObjeto[_FParam1[_FLocal1],1]==8 .and. _FObjeto[_FParam1[_FLocal1],7]<>0
            _FBotPadr:=If(_FObjeto[_FParam1[_FLocal1],7]==1 .or. _FObjeto[_FParam1[_FLocal1],7]==3, _FParam1[_FLocal1], _FBotPadr)
            _FBotFecha:=If(_FObjeto[_FParam1[_FLocal1],7]==2 .or. _FObjeto[_FParam1[_FLocal1],7]==3, _FParam1[_FLocal1], _FBotFecha)
        end
    else
        _FObjeto[_FParam1[_FLocal1],10]:=Form_CObj6(0, _FObjeto[_FParam1[_FLocal1],2], _FPLin+_FObjeto[_FParam1[_FLocal1],4], _FPCol+_FObjeto[_FParam1[_FLocal1],5], _FObjeto[_FParam1[_FLocal1],6], _FObjeto[_FParam1[_FLocal1],7], _FObjeto[_FParam1[_FLocal1],8], _FObjeto[_FParam1[_FLocal1],9], _FObjeto[_FParam1[_FLocal1],10])
    end
next
*
Return(0)

*****************************************************************************
*
*  -> Movimento do Formulario
*
Function Form_Move(_FParam1)
Local _FLocal1:=0, _FLocal2:=SaveScreen(24, 0, 24, 79),;
      _FLocal3:=SetColor(_CorAtenc)
*
SetPos(24,0);DispOut(Chr(32)+"<"+Chr(24)+Chr(25)+Chr(27)+Chr(26)+"> Move ≥ <F12>, <Enter> ou <Esc> Confirma"+Space(33))
SetColor(_CorPapel)
While .t.
    _FLocal1:=Inkey(0,128)
    If _FLocal1==-41 .or. _FLocal1==13 .or. _FLocal1==27
        exit
    ElseIf _FLocal1==5  // Movimenta a Janela para Cima
        If _FPLin>2
            Scroll(_FPLin-1, _FPCol, _FPLin+_FPTamLin, _FPCol+_FPTamCol, 1) // Rola coordenadas para cima
            RestScreen(_FPLin+_FPTamLin, 0, _FPLin+_FPTamLin, 79, _FParam1[1,_FPLin+_FPTamLin-1]) // Restaura linha abaixo
            _FPLin:=_FPLin-1
        end
    ElseIf _FLocal1==24 // Movimenta a Janela para Baixo
        If _FPLin+_FPTamLin<23
            Scroll(_FPLin, _FPCol, _FPLin+_FPTamLin+1, _FPCol+_FPTamCol, -1) // Rola coordenadas para baixo
            RestScreen(_FPLin, 0, _FPLin, 79, _FParam1[1,_FPLin-1]) // Restaura linha acima
            _FPLin:=_FPLin+1
        end
    ElseIf _FLocal1==19 // Movimenta a Janela para a Esquerda
        If _FPCol>0
            Scroll(_FPLin, _FPCol-1, _FPLin+_FPTamLin, _FPCol+_FPTamCol, 0, 1) // Rola coordenadas para esquerda
            RestScreen(2, _FPCol+_FPTamCol, 23, _FPCol+_FPTamCol, _FParam1[2,_FPCol+_FPTamCol+1]) // Restaura linha a direita
            _FPCol:=_FPCol-1
        end
    ElseIf _FLocal1==4  // Movimenta a Janela para a Direita
        If _FPCol+_FPTamCol<79
            Scroll(_FPLin, _FPCol, _FPLin+_FPTamLin, _FPCol+_FPTamCol+1, 0, -1) // Rola coordenadas para direita
            RestScreen(2, _FPCol, 23, _FPCol, _FParam1[2,_FPCol+1]) // Restaura linha a esquerda
            _FPCol:=_FPCol+1
        end
    end
end
RestScreen(24, 0, 24, 79, _FLocal2)
SetColor(_FLocal3)
Return(0)

*****************************************************************************
*
*  -> Controle de Teclas
*
Function Form_Tecla()
Whil .t.
    If _SisHora[1]<>Time()
        SetColor(_CorNormal)
        _SisHora:={Time(), If(_SisHora[2]==2,1,2)}
        SetPos(24, 1);DispOut( Time()+Chr(If(_SisHora[2]==1,7,9)) )
    end
    _FTecla:=Inkey(,128)
    If _AjUso==0 .and. ((_FTecla==28 .and. Len(_AjTexto)>0) .or. _FTecla==-20 .or. _FTecla==-9 .or. _FTecla==-40)
        If _FTecla==-9
            FormCalend()
        ElseIf _FTecla==-40
            FormCalc()
        Else
            FormAj( If(_FTecla==28,0,1) )
        end
    ElseIf _FTecla==-47
        _FTecla:={SaveScreen(0,0,24,79), SetColor()}
        SetColor("00/00,00/00,00")
        Scroll();SetPos(12,40)
        Whil Inkey(0)<>-47
            Tone(20000, 0.1)
        end
        RestScreen(0,0,24,79,_FTecla[1])
        SetColor(_FTecla[2])
        _FTecla:=0
    ElseIf _FTecla<>0
        &_FOFuncao(1)
        Exit
    end
end
SetColor(_FPCor)
If _FTecla==-41 .or. (_FTecla==5 .or. _FTecla==19 .or. _FTecla==271) .or. (_FTecla==4 .or. _FTecla==9 .or. _FTecla==13 .or. _FTecla==24) .or. _FTecla==10 .or. _FTecla==27
    _FormAcao:=If(_FTecla==-41, 1, If(_FTecla==5 .or. _FTecla==19 .or. _FTecla==271, 3, If(_FTecla==4 .or. _FTecla==9 .or. _FTecla==13 .or. _FTecla==24, 4, If(_FTecla==10, 6, If(_FTecla==27, 7, _FormAcao)))))
end
Return(0)

*****************************************************************************
*
*   Funcao para retorno nulo
*
Function FormNulo()
Return(0)

*****************************************************************************
*
*  -> Fecha um formulario ao acionar um botao
*
*  _FParam1=Codigo que a funcao principal ira retornar
*
Function FormFechar(_FParam1)
If _FParam1==2
    _FormAcao:=2
end
Return(0)

*****************************************************************************
*
*  -> Encerra o form ao pressionar Enter#13 em qualquer objeto
*
*  _FParam1=Codigo que a funcao principal ira retornar
*
Function FormPadrao(_FParam1)
If _FParam1==1 .and. _FTecla==13
    _FTecla:=0
    _FormAcao:=6
end
Return(0)

*****************************************************************************
*
*  -> Transforma uma Expressao Caractere em Tabela
*
*  _FLocal1=Posicao de procura de um ; para pular uma linha
*  _FLocal2=Retorno da matriz (cada ; uma nova linha)
*
Func Form_TxTab(_FParam1)
Local _FLocal1, _FLocal2:={}
_FParam1+=Chr(59)
Whil .T.
    _FLocal1:=At(Chr(59), _FParam1)
    If _FLocal1==0
        Exit
    end
    AAdd(_FLocal2, SubStr(_FParam1, 0, _FLocal1-1))
    _FParam1:=SubStr(_FParam1, _FLocal1+1)
end
Return(_FLocal2)

*****************************************************************************
*****************************************************************************
***
***   Objetos que o formulario pode controlar
***
*****************************************************************************
*****************************************************************************
*
*  Objeto (1) -> TEXTO
*  Impressao do Objeto
*
*  _FParam1=Ativacao (1Com_Foco / 2Sem_Foco)
*  _FParam2=Estado (1Apresentar, 2Nao_Apresentar)
*  _FParam3=Linha Inicial
*  _FParam4=Coluna Inicial
*  _FParam5=Texto
*  _FParam6=Formato
*
Function Form_CObj1(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6)
Local _FLocal1
ColorSelect(0)
_FParam5:=Form_TxTab(_FParam5)
For _FLocal1:=1 to Len(_FParam5)
    SetPos(_FParam3+_FLocal1-1, _FParam4-If(_FParam6==Nil .or. _FParam6==0, 0, If(_FParam6==1, Int(Len(_FParam5[_FLocal1])/2) ,If(_FParam6==2, Len(_FParam5[_FLocal1])-1,0))) );DispOut( If(_FParam2==1, _FParam5[_FLocal1], Space(Len(_FParam5[_FLocal1]))) )
Next
Return(0)
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
*
*
*
*
*
*
*****************************************************************************
*
*  Objeto (2) -> CAIXA 3D
*  Impressao do Objeto
*
*  _FParam1=Ativacao (1Com_Foco / 2Sem_Foco)
*  _FParam2=Estado (1Apresentar, 2Nao_Apresentar)
*  _FParam3=Linha Inicial
*  _FParam4=Coluna Inicial
*  _FParam5=Tamanho da Linha
*  _FParam6=Tamanho da Coluna
*
Function Form_CObj2(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6)
Local _FLocal1
ColorSelect(0)
SetPos(_FParam3,_FParam4);DispOut( Chr(218)+Repl(Chr(196),_FParam6-1)+Chr(191) )
For _FLocal1:=_FParam3+1 to _FParam3+_FParam5-1
    ColorSelect(0)
    SetPos(_FLocal1,_FParam4);DispOut( Chr(179) )
    ColorSelect(5)
    SetPos(_FLocal1,_FParam4+_FParam6);DispOut( Chr(179) )
next
SetPos(_FParam3+_FParam5, _FParam4);DispOut( Chr(192)+Repl(Chr(196),_FParam6-1)+Chr(217) )
Return(0)
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
*
*
*
*
*
*
*****************************************************************************
*
*  Objeto (3) -> CAIXA DE EDICAO DE TEXTO
*  Controle do Objeto
*
*  _FParam1=Linha Inicial
*  _FParam2=Coluna Inicial
*  _FParam3=Texto
*  _FParam4=Formato
*  _FLocal1=Controle de Alteracao de Texto
*  _FLocal2=Controle de Alteracao do Modo de Insercao
*  _FLocal3=Controle de Alteracao de Posicao
*  _FLocal4=Posicao do cursor
*  _FLocal5=Tamanho do Texto
*  _FLocal6=Impressao de Texto
*
Function Form_Obj3(_FParam1, _FParam2, _FParam3, _FParam4)
Local _FLocal1:=1, _FLocal2:=1, _FLocal3:=1, _FLocal4:=1, _FLocal5:=Len(_FParam3), _FLocal6
Form_Obj3B(@_FParam3, _FParam4)
Form_CObj3(1, 1, _FParam1, _FParam2++, _FParam3, _FParam4)
*
Whil .t.
    If _FLocal1==1     // Reimprime Caixa de Edicao Caractere
        _FLocal6:=If(_FParam4==2, Form_Obj3B(@_FParam3, _FParam4), _FParam3)
        ColorSelect(3);SetPos(_FParam1, _FParam2);DispOut( _FLocal6 )
        _FLocal3:=1
        _FLocal1:=0
    end
    If _FLocal3==1     // Alterado a posicao do Cursor
        ColorSelect(4);SetPos(_FParam1, _FParam2+_FLocal4-1);DispOut( SubStr(_FLocal6, _FLocal4, 1) )
        _FLocal3:=0
    end
    *
    Form_Tecla()
    _FParam3:=_FObjeto[_FOAtual,6]
    *
    If _FTecla==22
        _FLocal2:=If(_FLocal2==1, 0, 1)
    ElseIf _FTecla==1 .or. _FTecla==6 .or. _FTecla==19 .or. _FTecla==4
        _FLocal3:=_FLocal4
        If _FTecla==1
            _FLocal4:=1
        ElseIf _FTecla==6
            _FLocal4:=_FLocal5
        ElseIf _FTecla==19
            _FormAcao:=If(_FormAcao==3,0,_FormAcao)
            _FLocal4:=If(_FLocal4<=1, 1, _FLocal4-1)
        ElseIf _FTecla==4
            _FormAcao:=If(_FormAcao==4,0,_FormAcao)
            _FLocal4:=If(_FLocal4>=_FLocal5, _FLocal5, _FLocal4+1)
        end
        If _FLocal3<>_FLocal4
            ColorSelect(3);SetPos(_FParam1, _FParam2+_FLocal3-1);DispOut(SubStr(_FLocal6, _FLocal3, 1))
            _FLocal3:=1
        else
            _FLocal3:=0
        end
    ElseIf _FTecla==7 .or. _FTecla==8 .or. (_FTecla>=32 .and. _FTecla<=126)
        If _FTecla==8
            _FTecla:=If(_FLocal4==1, 8, 7)
            _FLocal4:=If(_FLocal4<=1, 1, _FLocal4-1)
        end
        If _FTecla==7
            _FLocal1:=1
            _FParam3:=SubStr(_FParam3, 1, _FLocal4-1)+SubStr(_FParam3, _FLocal4+1)+Chr(32)
            _FObjeto[_FOAtual,6]:=_FParam3
            &_FOFuncao(2)
        ElseIf _FTecla>=32 .and. _FTecla<=126
            _FLocal1:=1
            If _FParam4==1
                _FTecla:=Asc(Upper(Chr(_FTecla)))
            end
            If _FTecla==34 .or. _FTecla==39 .or. _FTecla==94 .or. _FTecla==96 .or. _FTecla==126
                _FTecla:=Form_Ob3Ac(_FTecla, _FParam4)
            end
            If _FLocal2==1
                _FParam3:=SubStr(SubStr(_FParam3, 1, _FLocal4-1)+Chr(_FTecla)+SubStr(_FParam3, _FLocal4), 1, _FLocal5)
            Else
                _FParam3:=SubStr(_FParam3, 1, _FLocal4-1)+Chr(_FTecla)+SubStr(_FParam3, _FLocal4+1)
            end
            _FLocal4:=If(_FLocal4>=_FLocal5, _FLocal5, _FLocal4+1)
            _FObjeto[_FOAtual,6]:=_FParam3
            &_FOFuncao(2)
        end
    end
    *
    If _FormAcao<>0
        Form_Obj3B(@_FParam3, _FParam4)
        _FObjeto[_FOAtual, 6]:=_FParam3
        Exit
    end
end
Form_CObj3(0, 1, _FParam1, --_FParam2, _FParam3, _FParam4)
Return(0)

*****************************************************************************
*
*  Objeto (3) -> CAIXA DE EDICAO DE TEXTO
*  Acentuacao Grafica
*
*  _FParam1=Acentuacao
*  _FParam2=Formato (usado somente para diferenciar maiuscula)
*  _FLocal1=Caractere a ser Acentuado
*  _FLocal2=Contador
*  _FLocal3=Filtro (acento grafico: trema, agudo, cirunflexo, crase, til)
*  _FLocal4=Tabela dos caracteres acentuados
*
Function Form_Ob3Ac(_FParam1, _FParam2)
Local _FLocal1, _FLocal2, _FLocal3:=If(_FParam1==34, 1, If(_FParam1==39, 2, If(_FParam1==94, 3, If(_FParam1==96, 4, If(_FParam1==126, 5, 0) )))),;
      _FLocal4:={{"oî", "uÅ", "Oô", "Uö"}, {"a†", "eÇ", "i°", "o¢", "u£", "cá", "Aè", "Eê", "II", "Oô", "Uö", "CÄ"}, {"aÉ", "eá", "oä", "Aê", "Eî", "Oó"}, {"aÖ", "Aè"}, {"aÑ", "oî", "Aé", "Oô"}}
*
_FLocal1:=Inkey(0)
If _FParam2==1
    _FLocal1:=Asc(Upper(Chr(_FLocal1)))
end
If _FLocal3<>0
    For _FLocal2:=1 to Len(_FLocal4[_FLocal3])
        If SubStr(_FLocal4[_FLocal3, _FLocal2], 1, 1)==Chr(_FLocal1)
            _FParam1:=Asc(SubStr(_FLocal4[_FLocal3, _FLocal2], 2, 1))
        end
    next
end
Return(_FParam1)

*****************************************************************************
*
*  Objeto (3) -> CAIXA DE EDICAO DE TEXTO
*  Retorna texto previamente Formatado
*
*  _FParam1=Texto
*  _FParam2=Formato
*  _FLocal1=Tamanho do Texto (_FParam1)
*  _FLocal2=Variavel temporaria (retorno)
*
Function Form_Obj3B(_FParam1, _FParam2)
Local _FLocal1:=Len(_FParam1), _FLocal2
*
If _FParam2>=3 .and. _FParam2<=9
    _FLocal2:=Form_Obj3C(_FParam1)
end
If _FParam2==0 .or. _FParam2==1
    _FLocal2:=_FParam1
    *
ElseIf _FParam2==2   // SENHA
    _FLocal2:=SubStr( Repl(Chr(42),Len(Alltrim(_FParam1)))+Space(_FLocal1), 1, _FLocal1)
    *
ElseIf _FParam2==3   // Numerico Normal
    _FLocal2:=Space(_FLocal1-Len(_FLocal2))+_FLocal2
    *
ElseIf _FParam2==4   // Numerico com 2 casas decimais
    _FLocal2:=Space(_FLocal1-Len(_FLocal2))+SubStr(_FLocal2,1,Len(_FLocal2)-2)+","+SubStr(_FLocal2,Len(_FLocal2)-1,2)
    *
ElseIf _FParam2==5   // Data
    If Len(_FLocal2)==1 .or. Len(_FLocal2)==2
        If Val(SubStr(_FLocal2, 1, 2))<32
            _FLocal2:=If(Len(_FLocal2)==1,Chr(48),"")+_FLocal2+StrZero(Month(Date()), 2)+Str(Year(Date()), 4)
        end
    ElseIf Len(_FLocal2)==4 .or. Len(_FLocal2)==6
        If Val(SubStr(_FLocal2, 1, 2))<32 .and. Val(SubStr(_FLocal2, 3, 2))<13
            _FParam1:=SubStr(_FLocal2, 5, 2)
            _FLocal2:=SubStr(_FLocal2, 1, 4)
            _FLocal2:=_FLocal2+If(Len(_FParam1)==2, SubStr(Str(Year(Date()), 4), 1, 2)+_FParam1,    Str(Year(Date()),4) )
        end
    end
    _FLocal2:=SubStr(_FLocal2,1,2)+"/"+SubStr(_FLocal2,3,2)+"/"+SubStr(_FLocal2,5,4)
    _FLocal2:=DtoC(CtoD(_FLocal2))
    *
ElseIf _FParam2==6   // Fone
    _FLocal2:=SubStr(_FLocal2,1,10)
    _FLocal2:=If(Len(_FLocal2)==7, "049"+_FLocal2, _FLocal2)
    _FLocal2:=If(Len(_FLocal2)==10,   "("+SubStr(_FLocal2, 1, 3)+") "+SubStr(_FLocal2, 4, 3)+"-"+SubStr(_FLocal2, 7, 4),   "("+Space(3)+")"+Space(4)+"-"+Space(4) )
    *
ElseIf _FParam2==7   // CPF
    _FLocal2:=If(Len(_FLocal2)==11, SubStr(_FLocal2,1,3)+"."+SubStr(_FLocal2,4,3)+"."+SubStr(_FLocal2,7,3)+"-"+SubStr(_FLocal2,10,2),  Space(3)+"."+Space(3)+"."+Space(3)+"-"+Space(2) )
    *
ElseIf _FParam2==8   // CGC
    _FLocal2:=If(Len(_FLocal2)==14, SubStr(_FLocal2,1,2)+"."+SubStr(_FLocal2,3,3)+"."+SubStr(_FLocal2,6,3)+"/"+SubStr(_FLocal2,9,4)+"-"+SubStr(_FLocal2,13,2), Space(2)+"."+Space(3)+"."+Space(3)+"/"+Space(4)+"-"+Space(2) )
    *
ElseIf _FParam2==9   // CEP
    _FLocal2:=If(Len(_FLocal2)==5, _FLocal2+"000", _FLocal2)
    _FLocal2:=If(Len(_FLocal2)==8, SubStr(_FLocal2,1,5)+"-"+SubStr(_FLocal2,6,3),  Space(5)+"-"+Space(3) )
    *
end
If _FParam2>=3 .and. _FParam2<=9
    _FParam1:=Form_Obj3C(_FLocal2)
end
*
_FParam1:=SubStr(_FParam1+Space(_FLocal1),1,_FLocal1)
Return(_FLocal2)

*****************************************************************************
*
*  Objeto (3) -> CAIXA DE EDICAO DE TEXTO
*  Retorna apenas caracteres numericos em uma expressao caractere
*
*  _FParam1=Valor Caractere
*  _FLocal1=Contador
*  _FLocal2=Valor de Retorno caractere
*
Function Form_Obj3C(_FParam1)
Local _FLocal1, _FLocal2:=""
For _FLocal1:=1 to Len(_FParam1)
    If SubStr(_FParam1, _FLocal1, 1) $ "0123456789"
        _FLocal2:=_FLocal2+SubStr(_FParam1, _FLocal1, 1)
    end
next
Return(_FLocal2)

*****************************************************************************
*
*  Objeto (3) -> CAIXA DE EDICAO DE TEXTO
*  Impressao do Objeto
*
*  _FParam1=Ativacao (1Com_Foco / 2Sem_Foco)
*  _FParam2=Estado (1Apresentar, 2Nao_Apresentar)
*  _FParam3=Linha Inicial
*  _FParam4=Coluna Inicial
*  _FParam5=Texto
*  _FParam6=Formato
*  _FLocal1=Texto Formatado
*
Function Form_CObj3(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6)
Local _FLocal1:=Form_Obj3B(@_FParam5, _FParam6)
_FLocal1:=If(_FParam1==1, Space( Len(_FLocal1) ), _FLocal1)
ColorSelect( If(_FParam2==1, If(_FParam1==1, 3, 4), 0) )
SetPos(_FParam3, _FParam4); DispOut( If(_FParam2==1, Chr(If(_FParam1==1, 91, 32))+ _FLocal1 +Chr(If(_FParam1==1, 93, 32)),  Space(Len(_FLocal1)+2)) )
Return(0)
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
*
*
*
*
*
*
*****************************************************************************
*
*  Objeto (4) CAIXA DE VERIFICACAO
*  Controle do Objeto
*
*  _FParam1=Linha Inicial
*  _FParam2=Coluna Inicial
*  _FParam3=Selecao (1Selecionado/0Deselecionado)
*  _FParam4=Titulo
*
Function Form_Obj4(_FParam1, _FParam2, _FParam3, _FParam4)
Form_CObj4(1, 1, _FParam1, _FParam2, _FParam3, _FParam4)
Whil .t.
    Form_Tecla()
    If _FTecla==32
        _FObjeto[_FOAtual, 6]:=_FParam3:=If(_FParam3==1, 0, 1)
        ColorSelect(3)
        SetPos(_FParam1, _FParam2+2);DispOut( Chr(If(_FParam3==1,120,32)) )
        &_FOFuncao(2)
    ElseIf _FormAcao<>0
        Exit
    end
end
Form_CObj4(0, 1, _FParam1, _FParam2, _FParam3, _FParam4)
Return(0)

*****************************************************************************
*
*  Objeto (4) CAIXA DE VERIFICACAO
*  Impressao do Objeto
*
*  _FParam1=Ativacao (1Com_Foco / 2Sem_Foco)
*  _FParam2=Estado (1Apresentar, 2Nao_Apresentar)
*  _FParam3=Linha Inicial
*  _FParam4=Coluna Inicial
*  _FParam5=Selecao
*  _FParam6=Titulo
*
Function Form_CObj4(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6)
ColorSelect( If(_FParam2==1, If(_FParam1==1, 3, 4), 0) )
SetPos(_FParam3, _FParam4); DispOut( If(_FParam2==1, Chr(If(_FParam1==1, 91, 32)) +Chr(40)+ Chr(If(_FParam5==1,120,32)) +Chr(41)+Chr(32)+ _FParam6 +Chr(If(_FParam1==1, 93, 32)),  Space(Len(_FParam6)+6)) )
Return(0)
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
*
*
*
*
*
*
*****************************************************************************
*
*  Objeto (5) ESCOLHA DE OPCOES
*  Controle do Objeto
*
*  _FParam1=Linha Inicial
*  _FParam2=Coluna Inicial
*  _FParam3=Selecao (numero da opcao selecionada)
*  _FParam4=Opcoes da Lista
*
Function Form_Obj5(_FParam1, _FParam2, _FParam3, _FParam4)
Form_CObj5(1, 1, _FParam1, _FParam2, _FParam3, _FParam4)
Whil .t.
    If _FObjeto[_FOAtual, 6]<>_FParam3
        ColorSelect(0);SetPos(_FParam1+_FObjeto[_FOAtual, 6]-1, _FParam2);DispOut(Chr(32)+Chr(40)+Chr(32)+Chr(41)+Chr(32)+_FParam4[_FObjeto[_FOAtual, 6]]+Chr(32)) // Deseleciona o item atual
        ColorSelect(3);SetPos(_FParam1+_FParam3-1, _FParam2);DispOut(Chr(91)+Chr(40)+Chr(7)+Chr(41)+Chr(32)+_FParam4[_FParam3]+Chr(93)) // Seleciona o novo item
        _FObjeto[_FOAtual, 6]:=_FParam3
        &_FOFuncao(2)
    end
    Form_Tecla()
    If _FTecla==5
        _FParam3:=If(_FParam3==1, Len(_FParam4), _FParam3-1)
    ElseIf _FTecla==24 .or. _FTecla==32
        _FParam3:=If(_FParam3==Len(_FParam4), 1, _FParam3+1)
    ElseIf _FormAcao<>0
        Exit
    end
end
Form_CObj5(0, 1, _FParam1, _FParam2, _FParam3, _FParam4)
Return(0)

*****************************************************************************
*
*  Objeto (5) ESCOLHA DE OPCOES
*  Impressao do Objeto
*
*  _FParam1=Ativacao (1Com_Foco / 2Sem_Foco)
*  _FParam2=Estado (1Apresentar, 2Nao_Apresentar)
*  _FParam3=Linha Inicial
*  _FParam4=Coluna Inicial
*  _FParam5=Selecao
*  _FParam6=Opcoes da Lista
*  _FLocal1=Contador
*
Function Form_CObj5(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6)
Local _FLocal1
For _FLocal1:=1 to Len(_FParam6)
    ColorSelect( If(_FLocal1==_FParam5 .and. _FParam2==1, If(_FParam1==1, 3, 4), 0) )
    SetPos(_FParam3+_FLocal1-1, _FParam4);DispOut( If(_FParam2==1,Chr(If(_FParam1==1 .and. _FParam5==_FLocal1, 91, 32)) +Chr(40)+ Chr(If(_FParam5==_FLocal1, 7, 32)) +Chr(41)+Chr(32)+ _FParam6[_FLocal1] + Chr(If(_FParam1==1 .and. _FParam5==_FLocal1, 93, 32)),  Space(Len(_FParam6[_FLocal1])+6)) )
next
Return(0)
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
*
*
*
*
*
*
*****************************************************************************
*
*  Objeto (6) LISTA DE OPCOES
*  Controle do Objeto
*
*  _FParam1=Linha Inicial
*  _FParam2=Coluna Inicial
*  _FParam3=Tamanho em Linhas
*  _FParam4=Tamanho em Colunas
*  _FParam5=Selecao (numero do elemento selecionada)
*  _FParam6=Elementos da Lista
*  _FParam7=Numero do elemento que esta no topo da Lista
*  _FLocal1=Selecao Temporaria
*
Function Form_Obj6(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6, _FParam7)
Local _FLocal1:=_FParam5
_FParam7:=Form_Obj6B(1, _FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6, _FParam7)
Whil .t.
    If _FLocal1<>_FParam5
        _FLocal1:=_FParam5
        _FParam7:=Form_Obj6B(1, _FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6, _FParam7)
        &_FOFuncao(2)
    end
    Form_Tecla()
    If _FTecla==5
        _FormAcao:=If(_FormAcao==3,0,_FormAcao)
        _FParam5--
    ElseIf _FTecla==18
        _FParam5-=_FParam3-2
    ElseIf _FTecla==24 .or. _FTecla==32
        _FormAcao:=If(_FormAcao==4,0,_FormAcao)
        _FParam5++
    ElseIf _FTecla==3
        _FParam5+=_FParam3-2
    ElseIf _FTecla==1
        _FParam5:=1
    ElseIf _FTecla==6
        _FParam5:=Len(_FParam6)
    end
    IF _FormAcao<>0
        Exit
    end
    _FObjeto[_FOAtual,8]:=_FParam5:=If(_FParam5>Len(_FParam6), Len(_FParam6), If(_FParam5<1, 1, _FParam5) )
end
_FParam7:=Form_Obj6B(0, _FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6, _FParam7)
Return(0)

*****************************************************************************
*
*  Objeto (6) LISTA DE OPCOES
*  Reimprime os elementos da Lista
*
*  _FParam1=Ativacao (1Com_Foco / 2Sem_Foco)
*  _FParam2=Linha Inicial
*  _FParam3=Coluna Inicial
*  _FParam4=Tamanho em Linhas
*  _FParam5=Tamanho em Colunas
*  _FParam6=Selecao (numero do elemento selecionada)
*  _FParam7=Elementos da Lista
*  _FParam8=Numero do elemento que esta no topo da Lista
*  _FLocal1=Contador
*
Function Form_Obj6B(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6, _FParam7, _FParam8)
Local _FLocal1
*
If _FParam8==0 .or. _FParam6-_FParam8>_FParam4-2
    _FParam8:=_FParam6-(_FParam4-2)
    _FParam8:=If(_FParam8<1, 1, _FParam8)
ElseIf _FParam6<_FParam8
    _FParam8:=_FParam6
end
*
_FParam3++
ColorSelect(5)
SetPos(_FParam2+_FParam4, _FParam3+_FParam5-10);DispOut( StrZero(_FParam6,4) )
ColorSelect(0)
*
For _FLocal1:=_FParam8 to _FParam8+_FParam4-2
    ColorSelect( If(_FLocal1==_FParam6, If(_FParam1==1, 3, 4) , 0) )
    SetPos(++_FParam2, _FParam3);DispOut( Chr(If(_FParam1==1 .and. _FParam6==_FLocal1, 91, 32))+SubStr(_FParam7[_FLocal1]+Space(_FParam5), 1, _FParam5-3)+Chr(If(_FParam1==1 .and. _FParam6==_FLocal1, 93, 32)) )
    If _FLocal1==Len(_FParam7)
        exit
    end
next
Return(_FParam8)

*****************************************************************************
*
*  Objeto (6) -> LISTA DE ELEMENTOS
*  Impressao do Objeto
*
*  _FParam1=Ativacao (1Com_Foco / 2Sem_Foco)
*  _FParam2=Estado (1Apresentar, 2Nao_Apresentar)
*  _FParam3=Linha Inicial
*  _FParam4=Coluna Inicial
*  _FParam5=Tamanho em Linhas
*  _FParam6=Tamanho em Colunas
*  _FParam7=Selecao (numero do elemento selecionada)
*  _FParam8=Elementos da Lista
*  _FParam9=Numero do elemento que esta no topo da Lista
*
Function Form_CObj6(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6, _FParam7, _FParam8, _FParam9)
If _FParam2==1
    Form_CObj2(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6)
    SetPos(_FParam3+_FParam5, _FParam4+_FParam6-5);DispOut( "/"+StrZero(Len(_FParam8),4) )
Else
    Scroll(_FParam3, _FParam4, _FParam3+_FParam5, _FParam4+_FParam6)
end
If _FParam2==1
    _FParam9:=Form_Obj6B(_FParam1, _FParam3, _FParam4, _FParam5, _FParam6, _FParam7, _FParam8, _FParam9)
end
ColorSelect(0)
Return(_FParam9)
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
*
*
*
*
*
*
*****************************************************************************
*
*  Objeto (7) -> CONTROLE DE COR
*  Controle do Objeto
*
*  _FParam1=Linha Inicial
*  _FParam2=Coluna Inicial
*  _FParam3=Cor
*  _FLocal1=Controle de Alteracao de Posicao
*  _FLocal2=Posicao
*
Function Form_Obj7(_FParam1, _FParam2, _FParam3)
Local _FLocal1:=1, _FLocal2:=1
Form_Obj7B(_FParam1, _FParam2, _FParam3, _FLocal2, 1)
Whil .t.
    If _FObjeto[_FOAtual, 6]<>_FParam3 .or. _FLocal1<>_FLocal2
        Form_Obj7B(_FParam1, _FParam2, _FObjeto[_FOAtual, 6], _FLocal1, 0)
        Form_Obj7B(_FParam1, _FParam2, _FParam3, _FLocal2, 1)
        _FObjeto[_FOAtual, 6]:=_FParam3
        _FLocal1:=_FLocal2
        &_FOFuncao(2)
    end
    Form_Tecla()
    If _FTecla==19 .or. _FTecla==4 .or. _FTecla==32
        _FTecla:=If(_FTecla==32,4,_FTecla)
        _FParam3:=If( _FLocal2==1,   StrZero(Val(SubStr(_FParam3,1,2))+If(_FTecla==19,-1,1),2)+SubStr(_FParam3,3,3),    SubStr(_FParam3,1,3)+StrZero(Val(SubStr(_FParam3,4,2))+If(_FTecla==19,-1,1),2)   )
        _FParam3:=If( SubStr(_FParam3,1,2)=="-1", "15"+SubStr(_FParam3,3,3), _FParam3)
        _FParam3:=If( SubStr(_FParam3,1,2)=="16", "00"+SubStr(_FParam3,3,3), _FParam3)
        _FParam3:=If( SubStr(_FParam3,4,2)=="-1", SubStr(_FParam3,1,3)+"15", _FParam3)
        _FParam3:=If( SubStr(_FParam3,4,2)=="16", SubStr(_FParam3,1,3)+"00", _FParam3)
    ElseIf _FTecla==5 .or. _FTecla==24
        _FLocal2:=If(_FLocal2==1,2,1)
    ElseIf _FormAcao<>0
        Exit
    end
end
Form_Obj7B(_FParam1, _FParam2, _FParam3, _FLocal2, 0)
Return(0)

*****************************************************************************
*
*  Objeto (7) -> CONTROLE DE COR
*  Impressao do Objeto
*
*  _FParam1=Ativacao (1Com_Foco / 2Sem_Foco)
*  _FParam2=Estado (1Apresentar, 2Nao_Apresentar)
*  _FParam3=Linha Inicial
*  _FParam4=Coluna Inicial
*  _FParam5=Cor
*  _FLocal1=Cor temporaria
*  _FLocal2=Contador
*
Function Form_CObj7(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5)
Local _FLocal1:=SetColor(), _FLocal2
ColorSelect(0)
If _FParam2==1
    SetPos(_FParam3  , _FParam4);DispOut("1ß Plano")
    SetPos(_FParam3+2, _FParam4);DispOut("2ß Plano")
    For _FLocal2:=0 to 15
        SetColor(StrZero(_FLocal2,2)+"/00")
        SetPos(_FParam3,   (_FParam4+10)+_FLocal2*3);DispOut(Chr(219)+Chr(219))
        SetPos(_FParam3+2, (_FParam4+10)+_FLocal2*3);DispOut(Chr(219)+Chr(219))
    next
    SetColor(_FLocal1)
else
    Scroll(_FParam3-1, _FParam4, _FParam3+4, _FParam4+57)
end
Form_Obj7B(_FParam3, _FParam4, _FParam5, 1, 0)
Return(0)

*****************************************************************************
*
*  Objeto (7) -> CONTROLE DE COR
*  Auxilio para Objeto
*
*  _FParam1=Linha Inicial
*  _FParam2=Coluna Inicial
*  _FParam3=Cor
*  _FParam4=Posicao (Alterna entre a Cor do 1o. ou 2o. plano)
*  _FParam5=Acao (Imprimir ou Limpar Cor Selecionada)
*  _FLocal1=Cor Temporaria
*  _FLocal2=Valor do Primeiro Plano da Cor
*  _FLocal3=Valor do Segundo Plano da Cor
*
Function Form_Obj7B(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5)
Local _FLocal1:=SetColor(), _FLocal2:=Val(SubStr(_FParam3,1,2)), _FLocal3:=Val(SubStr(_FParam3,4,2))
ColorSelect(0)
DispBox( _FParam1-1+If(_FParam4==1,0,2),  (_FParam2+10)+(If(_FParam4==1,_FLocal2,_FLocal3)*3)-1,  _FParam1-1+If(_FParam4==1,0,2)+2,  (_FParam2+10)+(If(_FParam4==1,_FLocal2,_FLocal3)*3)+2,  If(_FParam5==1,"⁄ƒø≥Ÿƒ¿≥",Space(8)) )
SetColor(_FParam3)
Scroll(_FParam1+4, _FParam2, _FParam1+6, _FParam2+19)
SetPos(_FParam1+5, _FParam2+6);DispOut( "Exemplo" )
SetColor(_FLocal1)
Return(0)
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
*
*
*
*
*
*
*****************************************************************************
*
*  Objeto (8) -> BOTAO DE ATIVACAO
*  Controle do Objeto
*
*  _FParam1=Linha Inicial
*  _FParam2=Coluna Inicial
*  _FParam3=Titulo
*  _FParam4=Estilo (0=Normal, 1=Padrao, 2=Fecha, 3=Padrao_&_Fecha)
*
Function Form_Obj8(_FParam1, _FParam2, _FParam3, _FParam4)
Form_CObj8(1, 1, _FParam1, _FParam2, _FParam3, _FParam4)
Whil .t.
    Form_Tecla()
    If _FTecla==13 .or. _FTecla==32
        ColorSelect(0)
        SetPos(_FParam1, _FParam2);DispOut(Chr(32))
        SetPos(_FParam1+1, _FParam2+1);DispOut(Space(Len(_FParam3)+4))
        ColorSelect(3)
        SetPos(_FParam1, _FParam2+1);DispOut(Chr(91)+Chr(32)+_FParam3+Chr(32)+Chr(93))
        Set(14,0) // Set Type to 0
        Inkey(0.1)
        Form_CObj8(1, 1, _FParam1, _FParam2, _FParam3, _FParam4)
        Inkey(0.1)
        Set(14,1) // Set Type to 1
        _FormAcao:=0
        &_FOFuncao(2)
    end
    If _FormAcao<>0
        Exit
    end
end
Form_CObj8(0, 1, _FParam1, _FParam2, _FParam3, _FParam4)
Return(0)

*****************************************************************************
*
*  Objeto (8) -> BOTAO DE ATIVACAO
*  Impressao do Objeto
*
*  _FParam1=Ativacao (1Com_Foco / 2Sem_Foco)
*  _FParam2=Estado (1Apresentar, 2Nao_Apresentar)
*  _FParam3=Linha Inicial
*  _FParam4=Coluna Inicial
*  _FParam5=Titulo
*  _FParam6=Estilo (0=Normal, 1=Padrao, 2=Fecha, 3=Padrao_&_Fecha)
*
Function Form_CObj8(_FParam1, _FParam2, _FParam3, _FParam4, _FParam5, _FParam6)
ColorSelect( If(_FParam2==1, If(_FParam1==1,3,4) , 0) )
If _FParam2==1
    SetPos(_FParam3, _FParam4);DispOut( Chr(If(_FParam1==1, 91, If(_FParam6==1 .or. _FParam6==3, 60, 32)))+Chr(32)+_FParam5+Chr(32)+Chr(If(_FParam1==1, 93, If(_FParam6==1 .or. _FParam6==3, 62, 32))) )
    ColorSelect(5)
    SetPos(_FParam3, _FParam4+Len(_FParam5)+4);DispOut(Chr(220))
    SetPos(_FParam3+1, _FParam4+1);DispOut( Repl(Chr(223), Len(_FParam5)+4) )
else
    Scroll(_FParam3, _FParam4, _FParam3+1, _FParam4+4+Len(_FParam5))
end
Return(0)


*****************************************************************************
*****************************************************************************
***
***   FORMULARIO CALENDARIO
***
*****************************************************************************
*****************************************************************************
Function FormCalend()
_AjUso:=1
Formulario({{"FormCaleAt",5,30,17,47,"Calend†rio",_CorAj},  {2,1,,1,2,2,43},  {2,1,,4,15,10,30},  {1,1,,2,4,ExtensoDat(Date()),0},  {1,1,,7,17,"Dom Seg Ter Qua Qui Sex S†b",0},  {8,1,"FormCaleBt",5,2,"+ Ano",0},  {8,1,"FormCaleBt",7,2,"- Ano",0},  {8,1,"FormCaleBt",9,2,"+ Màs",0},  {8,1,"FormCaleBt",11,2,"- Màs",0},  {8,1,"FormCaleBt",13,2,"Hoje ",0},  {1,1,,15,2,"Ano:",0},  {3,1,,15,7,"1998",3},  {8,1,"FormCalAno",15,15,"Atualizar",0},  {8,1,,15,39,"Ok",3},  {1,0,,13,25,"01"+SubStr(DtoC(Date()),3,8),0}})
_AjUso:=0
Return(0)

*
* Atualiza o Calendario
*
* _FLocal1=Descricao dos meses
* _FLocal2=Numero do dia da semana para comecar a contagem
* _FLocal3=Linha para impressao dos dias do mes
* _FLocal4=Coluna para impressao dos dias do mes
* _FLocal5=Contador dos Dia
* _FLocal6=Ultimo dia do mes
*
Function FormCaleAt()
Local _FLocal1:={"Janeiro","Fevereiro","Maráo","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"},;
      _FLocal2:=DoW(CtoD(_FObjeto[15,6])), _FLocal3:=_FPLin+8, _FLocal4:=_FPCol+18,;
      _FLocal5, _FLocal6:=FormCaleUD(_FObjeto[15,6])
*
ColorSelect(0)
SetPos(_FPLin+5, _FPCol+17); DispOut( SubStr(_FLocal1[Val(SubStr(_FObjeto[15,6],4,2))]+" de "+SubStr(_FObjeto[15,6],7,4)+Space(27),1,27) )
_FLocal4:=_FLocal4+(4*(_FLocal2-1))
Scroll(_FPLin+8, _FPCol+18, _FPLin+13, _FPCol+43)
For _FLocal5:=1 to _FLocal6
    ColorSelect(If(_FLocal2==1,1,0))
    SetPos(_FLocal3, _FLocal4); DispOut(Str(_FLocal5,2))
    _FLocal3:=If(_FLocal2==7, _FLocal3+1, _FLocal3)
    _FLocal4:=If(_FLocal2==7, _FPCol+18 , _FLocal4+4)
    _FLocal2:=If(_FLocal2==7,1,_FLocal2+1)
next
_FObjeto[12,6]:=SubStr(_FObjeto[15,6],7,4)
Form_Obj({12})
Return(0)

*
* Retorna o ultimo dia do mes selecionado
*
* _FParam1=Data para achar o ultimo dia do mes
* _FLocal1=Contador e valor de Retorno
*
Function FormCaleUD(_FParam1)
Local _FLocal1
_FParam1:=SubStr(_FParam1,3,8)
For _FLocal1:=27 to 32
    If DtoC(CtoD(Str(_FLocal1,2)+_FParam1))=="  /  /    "
        Exit
    end
next
Return(_FLocal1-1)

*
* Acao dos Botoes
*
* _FParam1=Codigo que a funcao principal ira retornar
* _FLocal1=Valor do Mes atual
* _FLocal2=Valor do Ano atual
*
Function FormCaleBt(_FParam1)
Local _FLocal1:=Val(SubStr(_FObjeto[15,6],4,2)), _FLocal2:=Val(SubStr(_FObjeto[15,6],7,4))
If _FParam1==2
    _FObjeto[15,6]:=CtoD(_FObjeto[15,6])
    _FObjeto[15,6]:=_FObjeto[15,6]+If(_FOAtual==6 .and. _FLocal2<2099, 366,   If(_FOAtual==7 .and. _FLocal2>100, -360,    If(_FOAtual==8 .and. _FLocal2<2100,  If(_FLocal2==2099 .and. _FLocal1==12, 0, 31),    If(_FOAtual==9 .and. _FLocal2>99, If(_FLocal2==100 .and. _FLocal1==1, 0, -10), 0))))
    _FObjeto[15,6]:=If(_FOAtual==10, Date(), _FObjeto[15,6])
    _FObjeto[15,6]:="01"+SubStr(DtoC(_FObjeto[15,6]),3,8)
    _FormAcao:=0
    FormCaleAt()
end
Return(0)

*
* Caixa de Edicao do Ano
*
* _FParam1=Codigo que a funcao principal ira retornar
*
Function FormCalAno(_FParam1)
If _FParam1==2
    _FObjeto[12,6]:=If(Val(_FObjeto[12,6])<100, "100"+Space(1), If(Val(_FObjeto[12,6])>2099, "2099", _FObjeto[12,6]))
    _FObjeto[15,6]:="01"+SubStr(_FObjeto[15,6],3,4)+_FObjeto[12,6]
    _FormAcao:=0
    FormCaleAt()
end
Return(0)


*****************************************************************************
*****************************************************************************
***
***   FORMULARIO CALCULADORA
***
*****************************************************************************
*****************************************************************************
Function FormCalc()
_AjUso:=1
Formulario({{,6,50,16,27,"Calculadora",_CorAj}, {2,1,,1,2,3,23}, {1,1,,2,22,Space(14),2},  {1,1,,2,23,Chr(61),0},  {1,1,,3,22,Space(14),2},  {1,1,,3,23,Chr(32),0},  {8,1,"FormCalcBt",14,2,"Enter",1},  {8,1,"FormCalcBt",14,12,"L",0},  {8,1,,14,18,"Esc",2},  {8,1,"FormCalcBt",12,2,"0",0},  {8,1,"FormCalcBt",12,8,".",0},  {8,1,"FormCalcBt",12,14,Chr(27),0}, {8,1,"FormCalcBt",12,20,"+",0},  {8,1,"FormCalcBt",10,2,"1",0}, {8,1,"FormCalcBt",10,8,"2",0}, {8,1,"FormCalcBt",10,14,"3",0}, {8,1,"FormCalcBt",10,20,"-",0},  {8,1,"FormCalcBt",8,2,"4",0}, {8,1,"FormCalcBt",8,8,"5",0}, {8,1,"FormCalcBt",8,14,"6",0}, {8,1,"FormCalcBt",8,20,"*",0},  {8,1,"FormCalcBt",6,2,"7",0}, {8,1,"FormCalcBt",6,8,"8",0}, {8,1,"FormCalcBt",6,14,"9",0}, {8,1,"FormCalcBt",6,20,"/",0}})
_AjUso:=0
Return(0)

*
* Manipulacao da Calculadora
*
* _FParam1=Codigo que a funcao principal ira retornar
* _FLocal1=Valor temporaria
* _FLocal2=Tabela com codigo dos botoes da calculadora
*
Function FormCalcBt(_FParam1)
Local _FLocal1, _FLocal2:={13,76,27,48,46,8,43,49,50,51,45,52,53,54,42,55,56,57,47}
If _FParam1==1
    _FLocal1:=AScan(_FLocal2, _FTecla)
    _FLocal1:=If(_FLocal1==0, If(_FTecla==108, 2, 0), _FLocal1)
    If _FLocal1<>0
        _FOAtual:=_FLocal1+6
        _FormAcao:=9
        _FTecla:=0
        __KeyBoard(Chr(32))
    end
ElseIf _FParam1==2
    If _FOAtual==8   // Limpar
        _FObjeto[3,6]:=_FObjeto[5,6]:=Space(14)
        _FObjeto[4,6]:=Chr(32)
    ElseIf _FOAtual==10 .or. _FOAtual==11 .or. _FOAtual==14 .or. _FOAtual==15 .or. _FOAtual==16 .or. _FOAtual==18 .or. _FOAtual==19 .or. _FOAtual==20 .or. _FOAtual==22 .or. _FOAtual==23 .or. _FOAtual==24
        If _FOAtual<>11
            _FObjeto[5,6]:=SubStr(_FObjeto[5,6],2)+Chr(_FLocal2[_FOAtual-6])
        ElseIf At(Chr(46), _FObjeto[5,6])==0
            _FObjeto[5,6]:=SubStr(_FObjeto[5,6],2)+Chr(46)
        end
        _FObjeto[5,6]:=SubStr(_FObjeto[5,6], 1, 14)
        _FObjeto[5,6]:=Space(14-Len(_FObjeto[5,6]))+_FObjeto[5,6]
    ElseIf _FOAtual==12
        _FObjeto[5,6]:=SubStr(Chr(32)+_FObjeto[5,6], 1, Len(_FObjeto[5,6]))
    ElseIf _FOAtual==7 .or. _FOAtual==13 .or. _FOAtual==17 .or. _FOAtual==21 .or. _FOAtual==25
        If _FObjeto[3,6]==Space(14)
            _FObjeto[3,6]:=_FObjeto[5,6]
        Else
            If _FObjeto[5,6]<>Space(14)
                If _FObjeto[4,6]<>Chr(61)
                    _FObjeto[3,6]:=FormCalcOp(_FObjeto[3,6], _FObjeto[4,6], _FObjeto[5,6])
                else
                    _FObjeto[3,6]:=_FObjeto[5,6]
                end
            end
        end
        _FObjeto[4,6]:=Chr(If(_FOAtual==7, 61, _FLocal2[_FOAtual-6]))
        _FObjeto[5,6]:=Space(14)
    end
    Form_Obj({3,4,5})
end
Return(0)

*
* Retorna uma string formatada ja calculada
*
* _FParam1=Operador1
* _FParam2=Operador Matematico
* _FParam3=Operador2
*
Function FormCalcOp(_FParam1, _FParam2, _FParam3)
_FParam1:=Val(_FParam1)
_FParam3:=Val(_FParam3)
If _FParam2=="+"
    _FParam1:=_FParam1+_FParam3
ElseIf _FParam2=="-"
    _FParam1:=_FParam1-_FParam3
ElseIf _FParam2=="*"
    _FParam1:=_FParam1*_FParam3
ElseIf _FParam2=="/"
    _FParam1:=_FParam1/_FParam3
end
Return( Str(_FParam1,14,2) )


*****************************************************************************
*****************************************************************************
***
***   FORMULARIO AJUDA
***
*****************************************************************************
*****************************************************************************
*
* _FParam1=Modo de Ajuda (0=Normal, 1=Introducao)
* _FLocal1=Contador
* _FLocal2=Cor temporaria
*
Function FormAj(_FParam1)
Local _FLocal1, _FLocal2:=SetColor(_CorAj)
_AjUso:=1
*
* Efeito especial
For _FLocal1:=0 to 4
    ColorSelect( If(Int(_FLocal1/2)-_FLocal1/2==0,0,1) )
    SetPos(24,62);DispOut(" Ajuda ao Usu†rio ")
    Inkey(0.02)
Next
*
Formulario( {{,3,6,19,66,If(_FParam1==0,"Ajuda ao usu†rio !","IntroduáÑo ao Sistema !"),_CorAj}, {6,1,"FormPadrao",2,2,13,62,1,If(_FParam1==0, Form_TxTab(_AjCabec+_AjTexto), _AjIntro),0}, {8,1,,17,54,"Fechar",3}} )
_AjUso:=0
SetColor(_FLocal2)
Return(0)


*****************************************************************************
*****************************************************************************
***
***   FORMULARIO PADRONIZADO
***
*****************************************************************************
*****************************************************************************
*
*  -> Formulario de Mensagens Padronizadas
*
*  _FParam1=Titulo
*  _FParam2=Texto
*  _FParam3=Cor
*  _FParam4=Estilo da janela (0=Mensagem, 1=BotaoOk, 2=BotaoSimNao)
*  _FLocal1=Linha Inicial
*  _FLocal2=Coluna Inicial
*  _FLocal3=Tamanho em Linhas
*  _FLocal4=Tamanho em Colunas
*  _FLocal5=Valor de Retorno do botao pressionado ou da tela de fundo da janela
*  _FLocal6=Cor temporaria
*
Function FormMens(_FParam1, _FParam2, _FParam3, _FParam4)
Local _FLocal1:=0, _FLocal2:=0, _FLocal3:=3, _FLocal4:=0, _FLocal5, _FLocal6:=SetColor()
SetColor(_FParam3)
_FLocal5:=Form_TxTab(_FParam2)
_FLocal3+=Len(_FLocal5)
For _FLocal1:=1 to Len(_FLocal5)
    _FLocal2:=If(Len(_FLocal5[_FLocal1])>_FLocal2, Len(_FLocal5[_FLocal1]), _FLocal2)
next
_FLocal4:=_FLocal2+6
_FLocal1:=Int( (25-_FLocal3)/2 )
_FLocal2:=Int( (80-_FLocal4)/2 )
If _FParam4==Nil .or. _FParam4==0
    _FLocal5:={_FLocal1, _FLocal2, _FLocal1+_FLocal3, _FLocal2+_FLocal4, SaveScreen(_FLocal1, _FLocal2, _FLocal1+_FLocal3, _FLocal2+_FLocal4)}
    Form_Jan(_FParam1, _FLocal1, _FLocal2, _FLocal3, _FLocal4)
    Form_CObj1(1,1,_FLocal1+2,_FLocal2+Int(_FLocal4/2),_FParam2,1)
ElseIf _FParam4==1
    _FLocal5:=Formulario( {{, _FLocal1-1, _FLocal2, _FLocal3+2, _FLocal4, _FParam1, _FParam3}, {1,1,,2,Int(_FLocal4/2),_FParam2,1}, {8,1,,3+Len(_FLocal5),Int(_FLocal4/2)-3,"Ok",3}} )-2
ElseIf _FParam4==2
    _FLocal5:=Formulario( {{, _FLocal1-1, _FLocal2, _FLocal3+2, _FLocal4, _FParam1, _FParam3}, {1,1,,2,Int(_FLocal4/2),_FParam2,1}, {8,1,,3+Len(_FLocal5),Int(_FLocal4/2)-8,"Sim",1}, {8,1,,3+Len(_FLocal5),Int(_FLocal4/2)+1,"NÑo",2}} )-2
end
SetColor(_FLocal6)
Return(_FLocal5)

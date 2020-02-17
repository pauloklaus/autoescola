*****************************************************************************
*****************************************************************************
***
***   Funcoes para Controle de Tabelas em Clipper 5.3
***   Paulo Sergio Klaus
***   BDADOS.PRG
***
*****************************************************************************
*****************************************************************************
*
* _BArquivo={Manipulador, Nome_Arq, Byte, {{Campo1,Ini1,Tam1,Format1}, {Campo2,Ini2,Tam2,Format2}}, {Ind1, Ind2}, TamReg, Selec, {Registros}, Alteracao}
*
*****************************************************************************
*
*  -> Salva um Banco de Dados
*
*  _BParam1=Matriz de Arquivo de Dados
*  _BLocal1=Contador
*  _BLocal2=Retorno
*  _BLocal3=Janela
*
Function BDSalvar(_BParam1)
Local _BLocal1, _BLocal2:=0, _BLocal3:=FormMens(,"Salvando informa‡”es em ["+_BParam1[2]+"] ...", _CorNormal, 0)
Whil .t.
    If _BParam1[9]==0  // Salva apenas se a tabela foi alterada !
        Exit
    end
    *
    If File(_BParam1[2])
        If File(_BParam1[2]+"2")
            FErase(_BParam1[2]+"2")
        end
        FRename(_BParam1[2], _BParam1[2]+"2")
    end
    *
    _BParam1[1]:=FCreate(_BParam1[2],0)
    If FError()<>0
        FormMens("Erro <SalvArq1>", "Erro ao Abrir/Criar o arquivo;["+_BParam1[2]+"] !", _CorAtenc, 1)
        _BLocal2:=1
        Exit
    end
    *
    If FWrite( _BParam1[1], Chr(13)+Chr(10)+_SisDescr+Chr(13)+Chr(10)+_SisLicen+Chr(13)+Chr(10)+Chr(26)+Chr(_BParam1[3])+StrZero(Len(_BParam1[8]),4) ) <> (12+Len(_SisDescr)+Len(_SisLicen))
        FormMens("Erro <SalvArq2>", "O cabe‡alho do arquivo ["+_BParam1[2]+"];n„o pode ser gravado !", _CorAtenc, 1)
        _BLocal2:=1
        Exit
    end
    *
    For _BLocal1:=1 to Len(_BParam1[8])
        If FWrite(_BParam1[1], _BParam1[8,_BLocal1], _BParam1[6])<>_BParam1[6]
            FormMens("Erro <SalvArq3>", "Houve um erro ao salvar as infoma‡”es;em ["+_BParam1[2]+"] !;;Erro no registro "+StrZero(_BLocal1,4)+".", _CorAtenc, 1)
            _BLocal2:=1
            Exit
        end
    end
    _BParam1[9]:=0
    Exit
end
FClose(_BParam1[1])
RestScreen(_BLocal3[1], _BLocal3[2], _BLocal3[3], _BLocal3[4], _BLocal3[5])
Return(_BLocal2)

*****************************************************************************
*
*  -> Recupera um Banco de Dados
*
*  _BParam1=Matriz de Arquivo de Dados
*  _BLocal1=Contador
*  _BLocal2=Tamanho do Cabecalho do Arquivo/Quantidade de Registros
*  _BLocal3=Tamanho do Registro
*  _BLocal4=Retorno
*  _BLocal5=Janela
*
Function BDRecup(_BParam1)
Local _BLocal1, _BLocal2:=Space(12+Len(_SisDescr)+Len(_SisLicen)),;
      _BLocal3:=Space(_BParam1[6]), _BLocal4:=0,;
      _BLocal5:=FormMens(, "Recuperando informa‡”es de ["+_BParam1[2]+"] ...", _CorNormal, 0)
*
_BParam1[8]:={}
Whil .t.
    If !File(_BParam1[2])
        Exit
    end
    _BParam1[1]:=FOpen(_BParam1[2],18)
    If FError()<>0
        FormMens("Erro <RecupArq1>", "O arquivo de informa‡”es ["+_BParam1[2]+"];n„o pode ser acessado !", _CorAtenc, 1)
        _BLocal4:=1
        Exit
    end
    *
    FRead(_BParam1[1], @_BLocal2, Len(_BLocal2))
    If SubStr(_BLocal2, 1, Len(_BLocal2)-4) <> Chr(13)+Chr(10)+_SisDescr+Chr(13)+Chr(10)+_SisLicen+Chr(13)+Chr(10)+Chr(26)+Chr(_BParam1[3])
        FormMens("Erro <RecupArq2>", "As informa‡”es de ["+_BParam1[2]+"];est„o incorretas !", _CorAtenc, 1)
        _BLocal4:=1
        Exit
    end
    *
    _BLocal2:=Val( SubStr(_BLocal2, Len(_BLocal2)-3, 4) )
    *
    For _BLocal1:=1 to _BLocal2
        If FRead(_BParam1[1], @_BLocal3, _BParam1[6])<>_BParam1[6] .or. FError()<>0
            FormMens("Erro <RecupArq3>", "Houve um erro ao recuperar as;infoma‡”es de ["+_BParam1[2]+"] !", _CorAtenc, 1)
            _BLocal4:=1
            Exit
        end
        AAdd(_BParam1[8], _BLocal3)
    end
    exit
end
*
_BParam1[7]:=If(Len(_BParam1[8])>0,1,0)
FClose(_BParam1[1])
RestScreen(_BLocal5[1], _BLocal5[2], _BLocal5[3], _BLocal5[4], _BLocal5[5])
Return(_BLocal4)
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
*  Atualiza as informacoes em um Registro
*
*  _BParam1=Apresentacao da Janela (0/1)
*  _BParam2=Matriz de Arquivo de Dados
*  _BParam3=Informacoes do Registro a ser Incluido/Alterado
*  _BParam4=Acao (0=Incluir, 1=Alterar)
*  _BLocal1=Janela
*
Function BDAtualiz(_BParam1, _BParam2, _BParam3, _BParam4)
Local _BLocal1
If _BParam1==1
    _BLocal1:=FormMens(,"Aguarde, atualizando ["+Alltrim(SubStr(_BParam3, _BParam2[4,_BParam2[5,1],2], _BParam2[4,_BParam2[5,1],3]))+"] ...", _CorNormal, 0)
end
*
_BParam4:=If(_BParam4==Nil,0,_BParam4)
If _BParam4<>0
    BDExcluir(0, @_BParam2)
end
BDIncOrg(@_BParam2, _BParam3) // Insere o _BParam3 em _BParam2[8]
_BParam2[9]:=1  // Banco de Dados Alterado
*
If _BParam1==1
    RestScreen( _BLocal1[1], _BLocal1[2], _BLocal1[3], _BLocal1[4], _BLocal1[5])
end
Return(0)

*****************************************************************************
*
*  Insere Organizadamente um Registro em _BParam1[8]
*
*  _BParam1=Matriz de Arquivo de Dados
*  _BParam2=Novas informacoes do Registro a ser incluido
*  _BLocal1=Contador de Registros
*  _BLocal2=Contador do Indice (O indice eh o _BParam1[5], ou os campos para se organizar a tabela)
*  _BLocal3=Contador de Caracteres dentro de um campo
*  _BLocal4=Quando ele achar todas as letras iguais, ele passa pro proximo
*           campo, caso contrario ele fecha o contador de Indice e passa pro
*           proximo registro (0=ProxCampo, 1=ProximoReg)
*
Function BDIncOrg(_BParam1, _BParam2)
Local _BLocal1, _BLocal2, _BLocal3, _BLocal4
*
AAdd(_BParam1[8], Repl(Chr(255),_BParam1[6])) // Insere um registro nulo para ser baseado na inclusao do novo registro
For _BLocal1:=1 to Len(_BParam1[8])
    _BLocal4:=0
    For _BLocal2:=1 to Len(_BParam1[5])
        For _BLocal3:=_BParam1[4,_BParam1[5,_BLocal2],2]  to  _BParam1[4,_BParam1[5,_BLocal2],2]+_BParam1[4,_BParam1[5,_BLocal2],3]-1
            If Asc(SubStr(_BParam2,_BLocal3,1))==Asc(SubStr(_BParam1[8,_BLocal1],_BLocal3,1))
                Loop
            ElseIf Asc(SubStr(_BParam2,_BLocal3,1)) < Asc(SubStr(_BParam1[8,_BLocal1],_BLocal3,1))
                AIns(_BParam1[8], _BLocal1)
                _BParam1[7]:=_BLocal1
                _BParam1[8,_BLocal1]:=_BParam2
                Return(0)
            end
            _BLocal4:=1
            Exit
        next
        If _BLocal4==1
            Exit
        end
    next
next
Return(0)

*****************************************************************************
*
*  Procura uma Informacao qualquer no Banco de Dados _BParam2[8]
*
*  _BParam1=Apresentacao da Janela (0/1)
*  _BParam2=Matriz de Arquivo de Dados
*  _BParam3=1a. Expressao de Procura {Valor_d_Procura, Campo, Tipo_d_Procura}
*  _BParam4=2a. Expressao de Procura
*  _BLocal1=Janela
*  _BLocal2=Contador de Registros
*  _BLocal3=Indica quando encontrou (0=Nao, 1=Encontrou)
*
Function BDConsult(_BParam1, _BParam2, _BParam3, _BParam4)
Local _BLocal1, _BLocal2, _BLocal3:=0
If _BParam1==1
    _BLocal1:=FormMens(,"Aguarde, procurando ["+Alltrim(_BParam3[1])+"] ...", _CorNormal, 0)
end
*
If _BParam2[7]<>0
_BParam2[7]:=If(_BParam2[7]==1, 1, If(_BParam2[7]+1>Len(_BParam2[8]), _BParam2[7], _BParam2[7]+1))
For _BLocal2:=_BParam2[7] to Len(_BParam2[8])
    *
    If BDConsultX(_BParam3[1], _BParam3[3], SubStr(_BParam2[8,_BLocal2], _BParam2[4,_BParam3[2],2], _BParam2[4,_BParam3[2],3]))
        If _BParam4<>Nil
            If BDConsultX(_BParam4[1], _BParam4[3], SubStr(_BParam2[8,_BLocal2], _BParam2[4,_BParam4[2],2], _BParam2[4,_BParam4[2],3]))
                _BLocal3:=1
                Exit
            end
        else
            _BLocal3:=1
            Exit
        end
    end
next
end
*
If _BLocal3==1
    _BParam2[7]:=_BLocal2
end
*
If _BParam1==1
    RestScreen( _BLocal1[1], _BLocal1[2], _BLocal1[3], _BLocal1[4], _BLocal1[5])
    If _BLocal3==0
        FormMens("Consulta","A express„o ["+Alltrim(_BParam3[1])+"];n„o foi encontrada !", _CorAtenc, 1)
    end
end
*
Return( If(_BLocal3==1, _BParam2[7], 0) )

*
*  Retorna um valor Logico para auxilio com a funcao BDConsult()
*
*  _BParam1=Expressao a ser procurada
*  _BParam2=Tipo da Busca (0=Normal, 1=Exata)
*  _BParam3=Campo do Arquivo de Dados
*
Function BDConsultX(_BParam1, _BParam2, _BParam3)
Return( If(_BParam2==0, If(Alltrim(_BParam1)$_BParam3,.t.,.f.), If(_BParam1==_BParam3,.t.,.f.)) )

*****************************************************************************
*
*  -> Exclui um Registro de _BParam2[8]
*
*  _BParam1=Apresentacao da Janela (0/1)
*  _BParam2=Matriz de Arquivo de Dados
*  _BLocal1=Janela
*  _BLocal2=Confirmar Exclusao (1=Sim, 2=Nao)
*  _BLocal3=Campo Indice
*
Function BDExcluir(_BParam1, _BParam2)
Local _BLocal1, _BLocal2:=1,;
      _BLocal3:=Alltrim(SubStr(_BParam2[8,_BParam2[7]], _BParam2[4,_BParam2[5,1],2], _BParam2[4,_BParam2[5,1],3]))
*
If _BParam1==1
    _BLocal2:=If(FormMens("Exclus„o","Deseja excluir ["+_BLocal3+"] ?", _CorAtenc, 2)==1,1,0)
end
*
If _BLocal2==1
    If _BParam1==1
        _BLocal1:=FormMens(,"Aguarde, exclu¡ndo ["+_BLocal3+"] ...", _CorNormal, 0)
    end
    *
    _BParam2[8]:=ADel(_BParam2[8], _BParam2[7])
    _BParam2[8]:=ASize(_BParam2[8], Len(_BParam2[8])-1)
    _BParam2[7]:=1
    _BParam2[9]:=1  // Banco de Dados Alterado
    If _BParam1==1
        RestScreen( _BLocal1[1], _BLocal1[2], _BLocal1[3], _BLocal1[4], _BLocal1[5])
    end
end
Return(_BLocal2)

*****************************************************************************
*
*  -> Procura pelo proximo codigo a ser inserido em _BParam2[8]
*
*  _BParam1=Apresentacao da Janela (0/1)
*  _BParam2=Matriz de Arquivo de Dados
*  _BParam3=Campo Codigo
*  _BLocal1=Janela
*  _BLocal2=Contador
*  _BLocal3=Retorno
*
Function BDProxCod(_BParam1, _BParam2, _BParam3)
Local _BLocal1, _BLocal2, _BLocal3:=StrZero(Len(_BParam2[8])+1,4)
If _BParam1==1
    _BLocal1:=FormMens(,"Procurando pr¢ximo c¢digo ...",_CorNormal,0)
end
*
For _BLocal2:=1 to Len(_BParam2[8])
    _BParam2[7]:=1
    If BDConsult(0, _BParam2, {StrZero(_BLocal2,4), _BParam3, 1})==0
       _BLocal3:=StrZero(_BLocal2,4)
       Exit
    end
next
*
If _BParam1==1
    RestScreen( _BLocal1[1], _BLocal1[2], _BLocal1[3], _BLocal1[4], _BLocal1[5])
end
Return(_BLocal3)
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
*  Retorna os campos a serem editados de um registro em forma de tabela
*  Ex.: {Campo1, Campo2, ... , CampoN}
*
*  _BParam1=Matriz de Arquivo de Dados
*  _BLocal1=Contador
*  _BLocal2=Tabela de Retorno
*
Function BDRegistro(_BParam1)
Local _BLocal1, _BLocal2[Len(_BParam1[4])]
For _BLocal1:=1 to Len(_BParam1[4])
    _BLocal2[_BLocal1]:=SubStr(_BParam1[8,_BParam1[7]], _BParam1[4,_BLocal1,2], _BParam1[4,_BLocal1,3])
next
Return(_BLocal2)

*****************************************************************************
*
*  Retorna uma tabela, em cada linha um registro separando os campos
*  por dois espacos, Ex.: {"001  Paulo Sergio Klaus  22/09/1980"}
*
*  _BParam1=Matriz de Arquivo de Dados
*  _BLocal1=Contador
*  _BLocal2=Contador de Campos
*  _BLocal3=Tabela de Retorno
*
Function BDTabela(_BParam1)
Local _BLocal1, _BLocal2, _BLocal3:={}, _BLocal4:=FormMens(,"Gerando tabela formatada ...",_CorNormal,0)
For _BLocal1:=1 to Len(_BParam1[8])
    AAdd( _BLocal3, SubStr(_BParam1[8,_BLocal1],_BParam1[4,1,2],_BParam1[4,1,3]) )
    For _BLocal2:=2 to Len(_BParam1[4])
        _BLocal3[_BLocal1]+=Space(2)+Form_Obj3B(SubStr(_BParam1[8,_BLocal1],_BParam1[4,_BLocal2,2],_BParam1[4,_BLocal2,3]), _BParam1[4,_BLocal2,4])
    next
next
RestScreen(_BLocal4[1], _BLocal4[2], _BLocal4[3], _BLocal4[4], _BLocal4[5])
Return(_BLocal3)
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
*  Configura as opcoes para gerar relatorios, e chama uma funcao definida
*  _BOpcoes={AprTit1, Tit1, AprTit2, Tit2, AprDataHora, AprPag, Campos, Fim_de_Relatorio}
*
Function BDRelator(_BTabela, _BOpcoes)
Local _BRet:=0, _BForm:={{,7,9,12,61,"Gerador de Relat¢rio",_CorNormal}, {4,1,"BDRel_Op1",2,3,_BOpcoes[1],"T¡tulo1"}, {3,_BOpcoes[1],,2,17,SubStr(_BOpcoes[2]+Space(40),1,40),0}, {4,1,"BDRel_Op1",3,3,_BOpcoes[3],"T¡tulo2"}, {3,_BOpcoes[3],,3,17,SubStr(_BOpcoes[4]+Space(40),1,40),0}, {4,1,,5,3,_BOpcoes[5],"Data e Hora"}, {4,1,,6,3,_BOpcoes[6],"Numerar p ginas"}, {4,1,,7,3,_BOpcoes[7],"Alternar registros em negrito"}, {1,1,,8,3,"Arquivo:",0}, {3,1,,8,12,SPACE(8),1}, {8,1,,10,3,"Imprimir",1}, {8,1,,10,17,"Cancelar",2}, {8,1,"BDRel_Bot1",10,44,"Impressora",0}},;
      _BEnter:=Chr(13)+Chr(10), _BDataHora:=DtoC(Date())+", "+Time(),;
      _BAlterna:=1, _BCont, _BContMarg, _BLins:=0, _BPag:=0, _BPrn, _BJan
*
_AjTexto:="Gerador de Relat¢rio;;O Gerador de Relat¢rio ‚ usado toda a  vez  que  o  usu rio;deseja imprimir algum relat¢rio.;;Atrav‚s deste Gerador, ‚ poss¡vel definir algumas  configu-;ra‡”es de impress„o e selecionado o bot„o [Imprimir], gerar;um relat¢rio."
If Formulario(_BForm)==11
    _BOpcoes:={_BForm[2,6], Chr(27)+Chr(69)+_BForm[3,6]+Chr(27)+Chr(70), _BForm[4,6], Chr(27)+Chr(71)+Chr(27)+Chr(52)+_BForm[5,6]+Chr(27)+Chr(53)+Chr(27)+Chr(72), _BForm[6,6], _BForm[7,6], _BForm[8,6], _BOpcoes[8], _BOpcoes[9]}
    _AjTexto:="Gerador de Relat¢rios - Erro de Impress„o;;Ocorreu algum erro ao imprimir para a porta paralela  "+_ImpLpt+".;Para contornar o erro, verifique alguns poss¡veis defeitos:;;   Veja se a impressora est  conectada em "+_ImpLpt+";   Verifique se ela est  ligada e on-line;   No caso de falta de papel, alimente a impressora;;Caso o erro n„o  seja  contornado,  entre  em  contato  com;"+_SisPsk+"."
    *
    _BJan:=FormMens(,"Enviando relat¢rio a impressora;Imprimindo em "+_ImpLpt+" ...;;P gina 0000, Linha 0000, Registro 0000;;Pressione <Esc> para cancelar !",_CorNormal,0)
    SetColor(_CorNormal)
    *
    If Len(Alltrim(_BForm[10,6]))>0
        _BPrn:=FCreate(Alltrim(_BForm[10,6]),0)
    else
        _BPrn:=FOpen(_ImpLpt,1)
    end
    _BForm:=""
    _BRet:=FWrite(_BPrn, Chr(27)+Chr(64)+Chr(7)+Chr(27)+Chr(51)+Chr(_ImpEspLin)+Chr(27)+Chr(108)+Chr(_ImpMargE)+Chr(27)+Chr(81)+Chr(_ImpMargD)+Chr(27)+Chr(120)+Chr(_ImpQualid)+Chr(27)+Chr(107)+Chr(_ImpFonte)+Chr(27)+Chr(_ImpCpi))
    *
    For _BCont:=1 to Len(_BTabela)
        SetPos(13,28); DispOut(StrZero(_BPag,4))    //  Informacoes
        SetPos(13,40); DispOut(StrZero(_BLins,4))   //  da Impressao
        SetPos(13,55); DispOut(StrZero(_BCont,4))   //  Atual.
        *
        If Inkey()==27 .or. _BRet==0                // Tecla de Cancelamento
            Exit
        end
        *
        If _BLins==0            // Impressao do Cabecalho do Relatorio
            *
            _BLins:=_ImpMargS+1 // Margem Superior
            For _BContMarg:=1 to _ImpMargS
                FWrite(_BPrn, _BEnter)
            next
            *
            If _BOpcoes[1]==1   // Titulo Principal
                _BLins:=_BLins+1
                FWrite(_BPrn, _BOpcoes[2]+_BEnter)
            end
            If _BOpcoes[3]==1   // SubTitulo
                _BLins:=_BLins+1
                FWrite(_BPrn, _BOpcoes[4]+_BEnter)
            end
            _BLins:=_BLins+1
            FWrite(_BPrn, _BEnter)
            *
            If _BOpcoes[5]==1   // Data e Hora da Impressao
                _BLins:=_BLins+1
                FWrite(_BPrn, Chr(27)+Chr(15)+"Impresso em "+_BDataHora+Chr(18)+_BEnter)
            end
            If _BOpcoes[6]==1   // Numeracao de Paginas
                _BPag:=_BPag+1
                _BLins:=_BLins+1
                FWrite(_BPrn, Chr(27)+Chr(15)+"Pagina "+StrZero(_BPag,4)+Chr(18)+_BEnter)
            end
            If _BOpcoes[5]<>0 .or. _BOpcoes[6]<>0
                _BLins:=_BLins+1
                FWrite(_BPrn, _BEnter)
            end
            *
            * // Titulo dos Campos
            FWrite(_BPrn, Repl(Chr(61),Len(_BOpcoes[8]))+_BEnter+_BOpcoes[8]+_BEnter+Repl(Chr(61),Len(_BOpcoes[8]))+_BEnter+_BEnter)
            _BLins:=_BLins+4
        end
        *
        * // Impressao do Registro Atual (Registro Atual=_BCont)
        _BRet:=FWrite(_BPrn, If(_BOpcoes[7]==1 .and. _BAlterna==1,Chr(27)+Chr(69),"") + _BTabela[_BCont] + If(_BOpcoes[7]==1 .and. _BAlterna==1,Chr(27)+Chr(70),"") +_BEnter)
        *
        _BAlterna:=If(_BAlterna==0, 1, 0)           // Alternar em negrito
        _BLins:=If(_BLins==_ImpLinhas, 0, _BLins+1) // Contagem das Linhas
        If _BLins==0    // Se _BLins for 0, entao salta uma pagina
            FWrite(_BPrn, Chr(12))
        end
    next
    *
    * // Impressao de Fim de Relatorio
    FWrite(_BPrn, _BEnter+Chr(27)+Chr(69)+Alltrim(Str(_BCont-1,4))+" "+_BOpcoes[9]+Chr(27)+Chr(70)+Chr(12))
    FClose(_BPrn)
    *
    RestScreen(_BJan[1], _BJan[2], _BJan[3], _BJan[4], _BJan[5])
    If _BRet==0
        FormMens("Aten‡„o!", "Erro ao gerar relat¢rio!;;Pressione <F1> para saber;mais sobre este problema.", _CorAtenc, 1)
    end
end
Return(0)

*
*  Habilita/Desabilita os Titulos
*
Function BDRel_Op1(_Cod)
If _Cod==2
    _FObjeto[_FOAtual+1,2]:=_FObjeto[_FOAtual,6]
    Form_Obj({_FOAtual+1})
end
Return(0)

*
*  Chama as Configuracoes da Impressora
*
Function BDRel_Bot1(_Cod)
Local _Temp
If _Cod==2
    _Temp:=_AjTexto
    CfgImpr()
    _AjTexto:=_Temp
end
Return(0)

/*
Chr(27)+Chr(64) => Inicializacao da impressora
Chr(27)+Chr(8) => Desativa deteccao de falta de papel
Chr(27)+Chr(9) => Ativa deteccao de falta de papel
Chr(7) => Sinal Sonoro
********
Chr(13) => Retorno de Carro para inicio da linha
Chr(10) => Proxima linha
********
Chr(12) => Alimentacao de pagina
Chr(27)+Chr(67)+Chr(66) => Linhas na Pagina
Chr(27)+Chr(51)+Chr(30) => Espaco entre linhas
********
Chr(27)+Chr(108)+Chr(2) => Margem Esquerda
Chr(27)+Chr(81)+Chr(2) => Margem Direita
********
Chr(8) => Retorno de Carro em um caractere
********
Chr(27)+Chr(120)+Chr(0) => Qualidade 0=Rascunho 1=Carta
Chr(27)+Chr(107)+Chr(0) => Letra 0=Romam 1=SansSerif
********

Chr(27)+Chr(80) => Selecao de 10Cpi
Chr(27)+Chr(77) => Selecao de 12Cpi
*
Chr(15) => Condensado
Chr(27)+Chr(15) => Super Condensado
Chr(18) => Cancela Condensado
*
Chr(27)+Chr(87)+Chr(0) => Largura Dupla 1=Ligado 0=Desligado
*
Chr(27)+Chr(69) => Enfatizado
Chr(27)+Chr(70) => Desliga Enfatizado
*
Chr(27)+Chr(71) => Negrito
Chr(27)+Chr(72) => Desliga Negrito
*
Chr(27)+Chr(83)+Chr(0) => SobreEscrito
Chr(27)+Chr(83)+Chr(0) => SubEscrito
Chr(27)+Chr(84) => Desliga Sobre/SubEscrito
*
Chr(27)+Chr(52) => Italico
Chr(27)+Chr(53) => Desliga Italico
*
Chr(27)+Chr(45)+Chr(0) => Sublinhado 1=Ligado 0=Desligado
*
* -> Opcoes configuraveis
*
* 1 Porta de Comunicacao Lpt=1
* 2 Linhas na Pagina=66
* 3 Espaco entre Linhas=30
* 4 Margem Superior=2
* 5 Margem Esquerda=2
* 6 Margem Direita=2
* 7 Qualidade=0/1
* 8 Letra=0/1
* 9 Caracteres por Polegada=10/12
*/

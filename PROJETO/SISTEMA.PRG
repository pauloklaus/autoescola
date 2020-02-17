*****************************************************************************
*****************************************************************************
***
***   Controle Avancado de Sistema em Clipper 5.3
***   Paulo Sergio Klaus
***   SISTEMA.PRG
***
*****************************************************************************
*****************************************************************************
***
***   OPCOES DO SISTEMA
***
*****************************************************************************
*****************************************************************************
*
*  -> Inicia as opcoes do Sistema
*
Function SisInicio
Local _FLocal1
_SisDos:={SaveScreen(0,0,24,79), Row()} // Propriedades do Dos (Fundo e Lin)
*
* Configuracao dos Set's
SetMode(25,80)
Set( 4, "DD/MM/YYYY" ) // Set Date Format to "..."
Set( 17, "on" )        // Set Console On
SetBlink(.F.)
MSetCursor(0)
SetCursor(0)
    *
    *  Definicao das Variaveis de Sistema
    *
    _SisLstPap:={Chr(176), Chr(177), Chr(178), Chr(220)+Chr(223), Chr(32)}
    _AjCabec:=_SisDescr+";"+_SisLicen+";;"+Repl(Chr(196),59)+"; "
    _AjIntro:="Introdu‡„o;;Nesta introdu‡„o vocˆ ter  uma breve descri‡„o  sobre  como;se movimentar neste sistema, aprendendo um pouco mais sobre;cada item que ‚ disponibilizado na tela.;;"+Repl(Chr(196),59)+"; Comandos Padr”es;;Os comandos padr”es tratam de op‡”es que  estar„o  dispon¡-;veis durante toda a execu‡„o do sistema. As teclas  abaixo,;chamar„o estas op‡”es:;;  <F1> ....... Ajuda ao Usu rio;  <Ctrl+F1> .. Esta Introdu‡„o;  <F10> ...... Calend rio;  <F11> ...... Calculadora;  <F12> ...... Move a janela;  <Alt+F12> .. Tela Escura;;"+Repl(Chr(196),59)+"; Menu do Sistema;;O Menu do Sistema ‚ representado pelas op‡”es  disponibili-;zadas na parte superior  do  seu  v¡deo.  Cada  uma  destas;op‡”es, cont‚m v rios itens. Estes itens podem ser selecio-;nados e executados.;;Para se movimentar entre as op‡”es, ‚ pressionado seta para;a <esquerda> e para a <direita>. Para selecionar  um  item,;basta teclar seta para <cima> e para <baixo>. Utilizando  a;tecla <Enter> executa-se o item selecionado.;"+;
               ";Tamb‚m ‚ poss¡vel executar um item, pressionando o conjunto;de teclas exibido ao lado de cada descri‡„o do item.;;"+Repl(Chr(196),59)+"; Janelas (Formul rios) do Sistema;;As Janelas s„o formul rios  que  Informam ou Disponibilizam;op‡”es para controlar uma certa a‡„o.;;Elas s„o representadas  por  caixas,  contendo  geralmente,;textos explicativos,  bot”es  de  op‡„o,  entre  outros (um;exemplo claro, ‚ esta janela de Introdu‡„o, onde possui uma;lista para visualizar um texto explicativo, e um bot„o para;fech -la).;;Cada op‡„o dentro das Janelas, s„o conhecidos como objetos.;Para se mover entre estas op‡”es ou objetos,  basta  teclar;<Tab> ou <Shift+Tab>. (Esperimente nesta Janela !);;Existem v rios tipos de objetos:;;   Objeto: Caixa de Edi‡„o;;    As caixas de edi‡„o, s„o objetos que permitem a entrada;    de informa‡”es via teclado. Abaixo, as teclas que podem;    ser utilizadas neste objeto:;;    <Seta … direita>;    Move o cursor uma posi‡„o a direita;;"+;
               "    <Seta … esquerda>;    Move o cursor uma posi‡„o a esquerda;;    <Insert>;    Alterna entre os modos de Inser‡„o e Substitui‡„o;;    <BackSpace>;    Apaga o caracter a esquerda do cursor;;    <Delete>;    Apaga o caracter a direita do cursor;;    <Home>;    Vai para a primeira posi‡„o dentro da caixa de edi‡„o;;    <End>;    Vai para a £ltima posi‡„o dentro da caixa de edi‡„o;;    H  v rios tipos de caixa de edi‡„o, dentre elas existem;    as caixas para edi‡„o de datas, Cpf, Carteira de  Iden-;    tidade, telefone, Cep,  valores  num‚ricos  com  e  sem;    casas decimais. Para edit -las,  somente  ‚  necess rio;    que vocˆ indique as letras e/ou n£meros.  Ou  seja,  em;    uma caixa de edi‡„o para  inserir  uma  data,  vocˆ  s¢;    precisar  incluir os n£meros da data, observe abaixo:;;    Data:;    22091980;;    Ap¢s vocˆ pressionar <Tab> para avan‡ar para o  pr¢ximo;    objeto, ser  formatado o texto  digitado,  transforman-;    do-o em uma data, assim:;;"
    _FLocal1 :="    Data:;    22/09/1980;;   Objeto: Caixa de Verifica‡„o;;    S„o  op‡”es  alternativas,  ou  seja,  neste  objeto  ‚;    permitido mudar o estado de uma  op‡„o,  em  ligado  ou;    desligado. Quando a op‡„o estiver ligada,  aparecer   a;    letra x, e ao estar desligado n„o aparecer  nada.;    Para que isto aconte‡a, tecle <Barra de Espa‡o>.;;    Exemplo 1:  (x) Op‡„o ativada;    Exemplo 2:  ( ) Op‡„o desativada;;   Objeto: Escolha de Op‡”es;;    Representado por uma  lista  vertical  de  itens,  este;    objeto ‚  utilizado  para  escolher  uma  entre  v rias;    op‡”es. Para movimentar-se  entre  as  op‡”es,  utilize;    <Seta … Cima> e <Seta … Baixo>.;;    Exemplo:;     () Este ‚ um exemplo de escolha de op‡”es;     ( ) 2§ item de escolha;     ( ) 3§ item de escolha;;   Objeto: Lista de Elementos;;    A Lista de Elementos, ‚ semelhante ao objeto Escolha de;    Op‡”es. Mas com uma diferen‡a  fundamental,  as  listas;"+;
               "    podem conter centenas de  op‡”es.  Para  selecionar  um;    elemento, utilize <Seta … Cima> e <Seta … Baixo>.;;    Exemplo:;      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿;      ³ Exemplo de Lista ³;      ³ 2§ elemento      ³;      ³ 3§ elemento      ³;      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ;;   Objeto: Bot„o;;    Os Bot”es, s„o  objetos  que  servem  para  tomadas  de;    decis„o.  Com  eles,  vocˆ  confirma  ou  cancela   uma;    determinada fun‡„o ou opera‡„o. Para acionar um  bot„o,;    pressione <Enter> ou <Barra de Espa‡o>.;;    Sempre que houver bot”es em uma janela, ter   um  bot„o;    que ser  indicado como Padr„o. Um bot„o Padr„o,  cont‚m;    duas indica‡”es (<>), e pode ser acionado  de  qualquer;    outro lugar, pressionado-se <Ctrl+Enter>.;;    Exemplo:   < Exemplo >Ü;                ßßßßßßßßßßß;"
    _AjIntro:=Form_TxTab(_AjCabec+_AjIntro+_FLocal1)
    _FLocal1:=Nil
*
Sis_Cfg()
*
* Imprime Janela de Apresentacao
_FLocal1:=FormMens(,Space(5)+_SisDescr+Space(5)+";"+_SisLicen,_CorNormal,0)
Inkey(2)
RestScreen(_FLocal1[1], _FLocal1[2], _FLocal1[3], _FLocal1[4], _FLocal1[5])
*
* Montagem do Sistema
SetColor(_CorTitulo)
SetPos( 0, 0); DispOut( Space(80) )
SetPos( 0, 1); DispOut( _SisDescr+": "+_SisLicen )
SetColor(_CorNormal)
SetPos( 1, 0); DispOut( Space(80) )
SetPos(24, 0); DispOut( Space(80) )
SetPos(24,10); DispOut( Space(1)+Chr(179)+Space(49)+Chr(179)+Space(1) )
SetColor(_CorAj)
SetPos(24,62); DispOut( Space(1)+"Ajuda ao Usu rio"+Space(1) )
SetColor(_CorPapel)
SetPos( 2, 0); QQOut( Repl(_SisPapel, If(Len(_SisPapel)==2,879,1759)) ); DispOut( _SisPapel )
SetColor(_CorNormal)
*
Return(0)

*****************************************************************************
*
*  -> Atribui as cores e os dados de impressao para as variaveis corretas
*     utilizando a var Publica _SisCfg (configuracoes do sistema)
*
Function Sis_Cfg()
*
* Cores
_CorTitulo:=_SisCfg[1]
_CorNormal:=_SisCfg[2]+","+SubStr(_SisCfg[2],4,2)+"/"+SubStr(_SisCfg[2],1,2)+",,"+_SisCfg[3]+","+_SisCfg[ 4]+",00/"+SubStr(_SisCfg[2],4,2)
_CorAtenc :=_SisCfg[5]+","+SubStr(_SisCfg[5],4,2)+"/"+SubStr(_SisCfg[5],1,2)+",,"+_SisCfg[6]+","+_SisCfg[ 7]+",00/"+SubStr(_SisCfg[5],4,2)
_CorAj    :=_SisCfg[8]+","+SubStr(_SisCfg[8],4,2)+"/"+SubStr(_SisCfg[8],1,2)+",,"+_SisCfg[9]+","+_SisCfg[10]+",00/"+SubStr(_SisCfg[8],4,2)
_CorPapel :=_SisCfg[11]
*
* Papel de Parede
_SisPapel:=_SisLstPap[Val(_SisCfg[12])]
*
* Impressora
_ImpLpt   :="LPT"+Str(Val(_SisCfg[13]),1)
_ImpLinhas:=Val(_SisCfg[14])
_ImpEspLin:=Val(_SisCfg[15])
_ImpMargS :=Val(_SisCfg[16])
_ImpMargE :=Val(_SisCfg[17])
_ImpMargD :=Val(_SisCfg[18])
_ImpQualid:=Val(_SisCfg[19])-1
_ImpFonte :=Val(_SisCfg[20])-1
_ImpCpi   :=If(Val(_SisCfg[21])==1, 80, 77)
Return(0)

*****************************************************************************
*
*  -> Finaliza as opcoes de Sistema
*
Function SisFim(_FParam1)
SetColor("07/00,00/07")
Scroll();SetPos(0,0)
SetMode(25,80)
RestScreen(0,0,24,79,_SisDos[1])
SetPos(_SisDos[2],0)
QOut(_SisDescr+Chr(13)+Chr(10)+_SisLicen+Chr(13)+Chr(10))
If _FParam1<>Nil
    QOut(_FParam1+Chr(13)+Chr(10))
end
Return(0)

/*
#### SISTEMA ####
_SisPsk ...... Fabricante
_SisDescr .... Descricao do Sistema
_SisLicen .... Licenciado a
_SisCfg ...... Matriz das Configuracoes de Cores e Impressora
_SisCfgPdr ... Matriz das Configuracoes PADRAO de Cores e Impressora
_SisPapel .... Papel de Parede Selecionado
_SisLstPap ... Lista dos Papeis de Parede disponiveis

#### MENU ####
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

#### AJUDA AO USUARIO ####
_AjCab ...... Cabecalho da Ajuda
_AjTexto .... Texto do Ajuda ao Usuario
_AjUso ...... Estado (Em uso, Nao Utilizado)
_AjIntro .... Texto da Introducao do Sistema

#### CORES ####
_CorTitulo ... Cor do Titulo
_CorPapel .... Cor do Papel de Parede
_CorNormal ... Cor Normalmente utilizada
_CorAtenc .... Cor das mensagens que merecam Atencao
_CorAj ....... Cor das mensagens de Ajuda ao Usuario

#### IMPRESSORA ####
_ImpLpt ...... Porta paralela de Comunicacao com a impressora
_ImpLinhas ... Linhas na pagina
_ImpEspLin ... Espaco entre linhas (em pixel)
_ImpMargS .... Margem Superior (em linhas)
_ImpMargD .... Margem Direita (em caracteres)
_ImpMargE .... Margem Esquerda (em caracteres)
_ImpQualid ... Qualidade de impressao
_ImpFonte .... Fonte de Letra
_ImpCpi ...... Caracteres por Polegada (em uma linha)


#### ARQUIVOS DE CONFIGURACOES ####
.Inicio
\nConfigura‡”es.\n
5 Tit
5 Fundo
5 Normal_Texto
5 Normal_Objetos
5 Normal_Objeto_Selecionado
5 Atenc_Texto
5 Atenc_Objetos
5 Atenc_Objeto_Selecionado
5 Aj_Texto
5 Aj_Objetos
5 Aj_Objeto_Selecionado
5 Papel de Parede
5 Porta Paralela
5 Linhas
5 Espaco Entre Linhas
5 Margem Superior
5 Margem Esquerda
5 Margem Direita
5 Qualidade de Impressao
5 Fonte de Letra
5 Caracteres por Polegada (Cpp ou Cpi)
.Fim
.Tamanho=124
*/

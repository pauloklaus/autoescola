# Sistema para Gestão de Autoescolas

> **Setembro de 1998** · Meu primeiro programa em **CA-Clipper 5.2**

Este repositório guarda, com carinho, o código-fonte do primeiro sistema que desenvolvi profissionalmente, lá no início da minha carreira. Foi feito para uma autoescola e ajudava a automatizar a papelada do dia a dia: cadastro de alunos e emissão dos formulários exigidos pelo Detran.

Não é um projeto ativo: é uma peça de história. O código está como foi escrito em 1998, com os seus acertos e as suas gambiarras.

---

## O que o sistema faz

- **Cadastro de clientes**: inclusão, consulta, alteração e exclusão.
- **Renach**: preenchimento em três etapas e impressão do formulário para solicitação da CNH (Carteira Nacional de Habilitação), em formulário branco ou verde.
- **DAR 19**: geração do Documento de Arrecadação Estadual, com código de tributo, valores, multa, juros e total calculado.
- **Relatórios**: lista de todos os clientes ou ficha completa de um cliente.
- **Utilitários embutidos**: ajuda contextual, calendário e calculadora.

### Atalhos de teclado

| Tecla | Ação |
|---|---|
| `F1` | Ajuda |
| `Ctrl+F1` | Introdução ao sistema |
| `F2` | Controle de Clientes |
| `F3` | Controle de Renach |
| `F4` | Controle de DAR 19 |
| `F10` | Calendário |
| `F11` | Calculadora |
| `Esc` | Fechar |

---

## Telas

<!-- AJUSTAR: troque os nomes dos arquivos pelos reais da pasta TELAS -->

| | |
|---|---|
| ![Menu principal](TELAS/menu.png)<br>**Menu principal** | ![Controle de clientes](TELAS/clientes.png)<br>**Controle de clientes** |
| ![Inclusão de cliente](TELAS/inclusao.png)<br>**Inclusão de cliente** | ![Consulta de cliente](TELAS/consulta.png)<br>**Consulta de cliente** |
| ![Renach, etapa 1](TELAS/renach1.png)<br>**Renach, etapa 1** | ![Renach, etapa 2](TELAS/renach2.png)<br>**Renach, etapa 2** |
| ![Renach, etapa 3](TELAS/renach3.png)<br>**Renach, etapa 3** | ![DAR 19](TELAS/dar19.png)<br>**DAR 19** |

---

## Ambiente original

| Item | Detalhe |
|---|---|
| Linguagem | CA-Clipper 5.2 (Computer Associates) |
| Linker | Blinker |
| Extensor de memória DOS | Exospace |
| Sistema operacional | MS-DOS 6.0 ou superior |
| Vídeo | Modo texto 80×25, com paleta para monitor colorido e para monocromático |
| Impressão | Direta na porta LPT, com sequências ESC/P para impressoras matriciais, em formulários pré-impressos |
| Dados | Arquivo próprio `Autoesc.bd` (veja abaixo) |

<!-- AJUSTAR: preencha com o que você lembra -->
<!-- Versões do Blinker e do Exospace: -->
<!-- Computador e impressora da época: -->

---

## Como rodar hoje com o DOSBox

O programa roda em emuladores de DOS modernos, como [DOSBox](https://www.dosbox.com/), DOSBox-X ou DOSBox Staging.

1. Instale o DOSBox.
2. Obtenha o executável `AUTOESC.EXE` (veja a aba *Releases* ou compile, conforme a próxima seção).
3. Coloque o executável em uma pasta, por exemplo `~/autoescola`.
4. No `dosbox.conf` (seção `[autoexec]`), ou direto no prompt do DOSBox:

```
mount c ~/autoescola
c:
autoesc.exe
```

**Memória:** como o executável foi linkeditado com o Exospace (modo protegido), se ele não iniciar no DOSBox, tente o DOSBox-X ou aumente a memória emulada (`memsize` na seção `[dosbox]`).

**Impressão:** o sistema grava direto na porta paralela. No DOSBox, redirecione a porta `parallel1` para um arquivo ou use o DOSBox-X, que emula impressoras. Confira a documentação da versão que você usar, pois as opções variam.

---

## Como compilar

São necessários o CA-Clipper 5.2, o linker Blinker e o extensor Exospace (softwares proprietários, **não incluídos** neste repositório).

O fluxo original era: compilar os `.PRG` com o compilador do Clipper, gerando os `.OBJ`, e depois linkeditar com o Blinker, usando o Exospace para ampliar a memória disponível ao programa.

<!-- AJUSTAR: coloque aqui os comandos e o arquivo .LNK/.BLI que você usava -->

O `AUTOESC.PRG` referencia os demais arquivos do projeto, que ficam na pasta `PROJETO`: `Sistema.prg`, `Form.prg`, `Menus.prg`, `Funcoes.prg` e `BDados.prg`.

---

## Estrutura do repositório

```
autoescola/
├── AUTOESC.PRG   Programa principal, controles de Clientes, Renach e DAR 19
├── PROJETO/      Bibliotecas próprias: sistema, formulários, menus, funções, banco de dados
├── TELAS/        Imagens das telas do sistema
└── README.md
```

---

## Curiosidades técnicas

- **Framework próprio de interface.** Formulários, menus, listas, botões e a ajuda contextual foram construídos do zero, descritos como matrizes (arrays) que o motor de formulários interpreta.
- **Banco de dados próprio.** Os clientes ficam em um arquivo de registros de tamanho fixo (207 bytes cada, 14 campos), e não em DBF. O código limita o cadastro a 4.000 clientes.
- **Formulários pré-impressos.** O Renach e o DAR 19 são impressos posicionando cada campo, com espaços e quebras de linha, sobre o formulário de papel.
- **Dois esquemas de cor**, escolhidos em tempo de execução conforme o monitor fosse colorido ou monocromático.

---

## Observações sobre o código

- Os arquivos usam a codificação do DOS (CP850/CP437). Por isso os acentos aparecem quebrados no navegador. O código foi mantido exatamente como foi escrito.
- Os nomes dos arquivos seguem a convenção do DOS e não diferenciam maiúsculas de minúsculas, o que pode causar problemas em sistemas como Linux.
- O README original citava "DARF", mas o documento gerado pelo sistema é o **DAR 19** (arrecadação estadual).

---

## Autor

**Paulo Sergio Klaus** · [github.com/pauloklaus](https://github.com/pauloklaus)

Este é um projeto histórico, mantido apenas para registro.

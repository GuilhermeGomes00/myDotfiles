# Neovim IDE

Configuração modular para Neovim 0.12+, Arch Linux, Wayland e Kitty. O ponto de
entrada é `init.lua`; opções, autocmds e utilitários ficam em `lua/config/`, e
cada área de plugins possui um arquivo pequeno em `lua/plugins/`.

## Manutenção

- `:Lazy` gerencia plugins; as revisões ficam fixadas em `lazy-lock.json`.
- `:Mason` gerencia LSPs, formatadores, linters e adapters de debug.
- `:ConformInfo`, `:LspInfo` e `:checkhealth` ajudam no diagnóstico.
- Markdown usa o ftplugin nativo do Neovim, Treesitter (`markdown` e
  `markdown_inline`), LSP e completion geral. A continuação de listas usa um
  mapeamento local de Enter para manter os marcadores e incrementar números.
- `:FormatToggle` desativa ou reativa format on save no buffer atual.
- As sessões são salvas pelo Persistence ao sair, mas só são restauradas por
  comando. Abrir `nvim .` nunca restaura uma sessão automaticamente.
- Snippets pessoais seguem o formato VS Code em `snippets/`; os snippets C#
  iniciais estão em `snippets/csharp.json`.

## Dependências externas

Já instaladas neste sistema e necessárias para todos os recursos configurados:

```bash
sudo pacman -S --needed neovim git ripgrep fd fzf bat wl-clipboard \
  tree-sitter-cli nodejs npm dotnet-sdk go clang jdk-openjdk eslint
```

Finalidade:

- `git`: Gitsigns, root de projetos e plugins.
- `ripgrep`, `fd`, `fzf`, `bat`: busca e preview do FzfLua.
- `wl-clipboard`: clipboard `unnamedplus` no Wayland.
- `tree-sitter-cli`: compilação dos parsers da API atual do Treesitter.
- `nodejs` e `npm`: projetos JS/TS e ferramentas desse ecossistema.
- `dotnet-sdk`, `go`, `clang`, `jdk-openjdk`: SDKs/compiladores dos projetos.
- `eslint`: lint adicional de JS/TS; use a configuração ESLint do projeto.

O Mason já instalou, dentro dos dados do Neovim, os LSPs, formatadores,
linters e adapters usados pela configuração: Roslyn, gopls, vtsls,
BasedPyright, clangd, jdtls, lua-language-server, servidores web/dados,
CSharpier, gofumpt, Prettier, Ruff, clang-format, google-java-format, StyLua,
shfmt, Taplo, ShellCheck, cspell, netcoredbg, Delve, debugpy, js-debug,
codelldb e os bundles Java. Portanto, não é necessário duplicá-los no sistema.
O Roslyn vem do registro recomendado pelo `roslyn.nvim` e está na versão
5.12.0, compatível com o requisito atual do plugin.
O JUnit Platform Console 6.0.3 exigido pelo `neotest-java` também foi baixado
e teve o SHA-256 conferido.

Opcional:

```bash
sudo pacman -S --needed lazygit
```

`lazygit` habilita `<leader>gg`. A Nerd Font
`ttf-jetbrains-mono-nerd` já está instalada; selecione uma família Nerd Font no
Kitty se os ícones não aparecerem.

## Transparência

O Ashen usa fundo transparente, permitindo que o fundo do Kitty apareça.
Alpha real é responsabilidade do terminal. Para 90%, a opção correspondente
do Kitty é `background_opacity 0.90`; esta configuração não altera o Kitty.

## Keymaps

`<leader>` é espaço. Os movimentos e comandos nativos abaixo são os do Vim e
Neovim; os demais aparecem porque esta configuração os define explicitamente.

### Movimentação básica

| Keymap | Ação |
|---|---|
| `h` / `j` / `k` / `l` | esquerda / baixo / cima / direita |
| `w` / `b` / `e` | próxima palavra / palavra anterior / fim da palavra |
| `0` / `^` / `$` | início da linha / primeiro caractere não branco / fim da linha |
| `gg` / `G` | início / fim do buffer |
| `<C-d>` / `<C-u>` | descer / subir meia tela |
| `/` / `?`, `n` / `N` | buscar para frente / trás; próximo / anterior resultado |
| `%` | ir ao delimitador correspondente |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | navegar para a janela à esquerda / abaixo / acima / direita |
| `<Esc>` | limpar destaque da busca |

### Vim motions / text objects

| Keymap | Ação |
|---|---|
| `iw` / `aw` | palavra interna / palavra com espaços adjacentes |
| `i"` / `a"`, `i'` / `a'`, `` i` `` / `` a` `` | texto interno / incluindo aspas |
| `i(`/`a(`, `i[`/`a[`, `i{`/`a{` | texto interno / incluindo delimitadores |
| `af` / `if` | função ao redor / interior (Treesitter) |
| `ac` / `ic` | classe ao redor / interior (Treesitter) |
| `aa` / `ia` | argumento ao redor / interior (Treesitter) |
| `<leader>mf` / `<leader>mF` | próxima função / função anterior (Treesitter) |
| `<leader>mc` / `<leader>mC` | próxima classe / classe anterior (Treesitter) |
| `f` / `F` / `t` / `T` | buscar / mover até caractere na linha; Flash realça destinos e permite repetir |
| `<leader>j` | busca com rótulos Flash |
| `<leader>J` | busca de nós Treesitter com Flash |

### Keymaps pessoais

| Keymap | Ação |
|---|---|
| `H` / `L` | buffer anterior / próximo |
| `<leader>w` | salvar arquivo |
| `<leader>bd` / `<leader>q` | fechar buffer; pergunta se salva alterações |
| `<leader>Q` | fechar o Neovim |
| `<leader>nf` | criar arquivo genérico no diretório do buffer/projeto |
| `<leader>nc` / `<leader>nj` / `<leader>nh` | criar tipo C# / arquivo Java / arquivo C |
| `<` / `>` (visual) | diminuir / aumentar recuo mantendo seleção |

### nvim-tree.lua

| Keymap | Ação |
|---|---|
| `<leader>e` | abrir, focar ou fechar o explorer |
| `a` / `r` / `d` | criar / renomear / apagar arquivo ou diretório |
| `x` / `c` / `p` | recortar / copiar / colar |
| `H` | alternar arquivos ocultos |

### fzf-lua

| Keymap | Ação |
|---|---|
| `<leader>ff` / `<leader>fg` | procurar arquivo / texto no projeto |
| `<leader>fb` / `<leader>fw` | buffers / palavra sob o cursor |
| `<leader>fs` / `<leader>fS` | símbolos do arquivo / projeto |
| `<leader>fr` | referências LSP |
| `<leader>fc` / `<leader>fh` / `<leader>fo` | comandos / ajuda / arquivos recentes |

### blink.cmp

| Keymap | Ação |
|---|---|
| `<C-Space>` | abrir completion ou alternar documentação |
| `<C-n>` / `<C-p>` / `<Down>` / `<Up>` | próxima / anterior sugestão |
| `<Tab>` / `<S-Tab>` | próxima/anterior sugestão, avançar/voltar snippet; `<Tab>` também sai de pares com tabout se as ações anteriores não se aplicarem |
| `<CR>` | aceitar sugestão selecionada ou inserir nova linha |
| `<C-e>` | cancelar completion |
| `<C-k>` | alternar documentação da sugestão |
| `<C-b>` / `<C-f>` | rolar documentação da sugestão |

### tabout.nvim

| Keymap | Ação |
|---|---|
| `<Tab>` | sair de `()`, `[]`, `{}`, aspas e crases após Blink e snippets recusarem a tecla; nos demais casos mantém inserção/recuo padrão |

### flash.nvim

| Keymap | Ação |
|---|---|
| `<leader>j` | buscar texto com rótulos e saltar para uma posição |
| `<leader>J` | buscar e selecionar nós Treesitter |
| `f` / `F` / `t` / `T` | motions nativos realçados pelo Flash; `;` e `,` repetem o movimento |

### mini.surround

| Keymap | Ação |
|---|---|
| `sa` | adicionar delimitador em um movimento ou seleção visual |
| `sd` | apagar delimitador ao redor |
| `sr` | substituir delimitador |
| `sf` / `sF` | encontrar delimitador à direita / esquerda |
| `sh` | realçar delimitador |

### LSP e diagnósticos

| Keymap | Ação |
|---|---|
| `gd` / `gD` | definição / declaração |
| `grr` / `gri` | referências / implementação |
| `K` | hover/documentação |
| `<leader>rn` / `<leader>ca` | renomear símbolo / ação de código |
| `[d` / `]d` | diagnóstico anterior / próximo |
| `<leader>cd` / `<leader>ch` | diagnóstico da linha / alternar inlay hints |

### Conform

| Keymap | Ação |
|---|---|
| `<leader>cf` | formatar buffer ou seleção |

### Trouble

| Keymap | Ação |
|---|---|
| `<leader>xx` / `<leader>xb` | diagnósticos do projeto / buffer |
| `<leader>xs` / `<leader>xr` / `<leader>xq` | símbolos / referências / quickfix |
| `<leader>xt` | TODOs no Trouble |

### gitsigns.nvim

| Keymap | Ação |
|---|---|
| `]h` / `[h` | próximo / anterior hunk |
| `<leader>gs` / `<leader>gr` | stage / reset hunk |
| `<leader>gp` / `<leader>gb` / `<leader>gd` | preview / alternar blame / diff do arquivo |

### Snacks.terminal

| Keymap | Ação |
|---|---|
| `<leader>tt`, `<C-'>`, `<C-/>` ou `<C-_>` | alternar o mesmo terminal flutuante do projeto |
| `<leader>gg` | abrir/alternar LazyGit (requer `lazygit`) |
| `<Esc><Esc>` | sair do modo terminal |
| `q` (padrão Snacks) | esconder a janela do terminal |
| `gf` (padrão Snacks) | abrir o arquivo sob o cursor |

### nvim-dap

| Keymap | Ação |
|---|---|
| `<F5>` / `<F9>` | iniciar/continuar debug / alternar breakpoint |
| `<F10>` / `<F11>` / `<S-F11>` | step over / into / out |
| `<leader>du` / `<leader>dr` | interface / REPL do debugger |
| `<leader>dx` / `<leader>dl` | encerrar / repetir debug |

### neotest

| Keymap | Ação |
|---|---|
| `<leader>tn` / `<leader>tf` / `<leader>ta` | testar função / arquivo / suíte |
| `<leader>td` / `<leader>ts` | debugar teste / alternar resumo |
| `<leader>to` / `<leader>tp` | abrir output / alternar painel |

### persistence.nvim

| Keymap | Ação |
|---|---|
| `<leader>ss` / `<leader>sS` | restaurar sessão do projeto / selecionar sessão |
| `<leader>sl` / `<leader>sd` | restaurar última sessão / não salvar sessão atual |

### todo-comments.nvim

| Keymap | Ação |
|---|---|
| `]t` / `[t` | próximo / anterior TODO |
| `<leader>ft` | procurar TODOs |

### Markdown local

| Keymap | Ação |
|---|---|
| `<CR>` em item de lista | continuar lista com o mesmo marcador ou próximo número |

`nvim-colorizer.lua` não define keymaps; oferece os comandos `:ColorizerToggle`,
`:ColorizerAttachToBuffer`, `:ColorizerDetachFromBuffer` e
`:ColorizerReloadAllBuffers`.

O Markdown mantém `formatoptions`, `comments` e `formatlistpat` do ftplugin
nativo; um mapeamento local de Enter continua marcadores `-`, `*`, `+` e listas
numeradas. O mapeamento primeiro aceita completion do Blink e mantém o
comportamento de pares do nvim-autopairs fora de itens de lista. LSP,
completion, formatação e spellcheck são gerais e continuam disponíveis em
Markdown.

Os comandos de criação geram uma classe Java executável com
`public static void main`, um arquivo C com `int main(void)`, ou, no caso do
C#, mantêm a seleção existente entre Class, Interface, Record, Enum e
Controller.

# Neovim IDE

Configuração modular para Neovim 0.12+, Arch Linux, Wayland e Kitty. O ponto de
entrada é `init.lua`; opções, autocmds e utilitários ficam em `lua/config/`, e
cada área de plugins possui um arquivo pequeno em `lua/plugins/`.

## Manutenção

- `:Lazy` gerencia plugins; as revisões ficam fixadas em `lazy-lock.json`.
- `:Mason` gerencia LSPs, formatadores, linters e adapters de debug.
- `:ConformInfo`, `:LspInfo` e `:checkhealth` ajudam no diagnóstico.
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

O Kanagawa usa fundo transparente, permitindo que o fundo do Kitty apareça.
Alpha real é responsabilidade do terminal. Para 90%, a opção correspondente
do Kitty é `background_opacity 0.90`; esta configuração não altera o Kitty.

## Atalhos

`<leader>` é espaço.

| Atalho | Ação |
|---|---|
| `<leader>e` | abrir, focar ou fechar o NvimTree |
| `<leader>nf` | criar arquivo genérico |
| `<leader>nc` | criar tipo C# |
| `<leader>nj` | criar arquivo Java |
| `<leader>nh` | criar arquivo C |
| `H` / `L` | buffer anterior / próximo |
| `<leader>bd` | fechar buffer com confirmação se modificado |
| `<leader>w` | salvar |
| `<C-h/j/k/l>` | navegar entre janelas |
| `<Esc>` | limpar destaque da busca |
| `<leader>ff` / `<leader>fg` | procurar arquivo / texto no projeto |
| `<leader>fb` / `<leader>fw` | buffers / palavra sob o cursor |
| `<leader>fs` / `<leader>fS` | símbolos do arquivo / projeto |
| `<leader>fr` | referências |
| `<leader>fc` / `<leader>fh` / `<leader>fo` | comandos / ajuda / recentes |
| `gd` / `gD` | definição / declaração |
| `grr` / `gri` | referências / implementação |
| `K` | hover/documentação |
| `<leader>rn` / `<leader>ca` | renomear / ação de código |
| `[d` / `]d` | diagnóstico anterior / próximo |
| `<leader>cd` / `<leader>ch` | diagnóstico da linha / inlay hints |
| `<leader>cf` | formatar |
| `<leader>xx` / `<leader>xb` | diagnósticos do projeto / buffer |
| `<leader>xs` / `<leader>xr` / `<leader>xq` | símbolos / referências / quickfix |
| `<leader>xt` | TODOs no Trouble |
| `]h` / `[h` | próximo / anterior hunk Git |
| `<leader>gs` / `<leader>gr` | stage / reset hunk |
| `<leader>gp` / `<leader>gb` / `<leader>gd` | preview / blame / diff |
| `<leader>gg` | LazyGit flutuante, quando instalado |
| `<leader>tt` ou `<C-/>` | terminal flutuante |
| `<Esc><Esc>` | sair do modo terminal |
| `F5` / `F9` | continuar/iniciar debug / breakpoint |
| `F10` / `F11` / `Shift-F11` | step over / into / out |
| `<leader>du` / `<leader>dr` | interface / REPL do debugger |
| `<leader>dx` / `<leader>dl` | encerrar / repetir debug |
| `<leader>tn` / `<leader>tf` / `<leader>ta` | teste próximo / arquivo / suíte |
| `<leader>td` / `<leader>ts` | debugar teste / resumo |
| `<leader>to` / `<leader>tp` | output / painel de testes |
| `<leader>ss` / `<leader>sS` | restaurar sessão do projeto / selecionar |
| `<leader>sl` / `<leader>sd` | última sessão / não salvar esta sessão |
| `]t` / `[t` / `<leader>ft` | próximo TODO / anterior / procurar TODOs |

Os atalhos de criação geram uma classe Java executável com
`public static void main`, um arquivo C com `int main(void)`, ou, no caso do
C#, mantêm a seleção existente entre Class, Interface, Record, Enum e
Controller.

No NvimTree, `a`, `r`, `d`, `x`, `c`, `p` e `H` seguem os mapeamentos padrão
atuais para criar, renomear, apagar, recortar, copiar, colar e alternar arquivos
ocultos.

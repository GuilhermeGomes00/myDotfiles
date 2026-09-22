return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    cond = function()
      return not vim.g.started_with_directory and vim.fn.argc(-1) == 0
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "doom",
      hide = { statusline = false, tabline = true, winbar = true },
      config = {
        header = {
          "",
          "     ███╗   ██╗██╗   ██╗██╗███╗   ███╗     ",
          "     ████╗  ██║██║   ██║██║████╗ ████║     ",
          "     ██╔██╗ ██║██║   ██║██║██╔████╔██║     ",
          "     ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║     ",
          "     ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║     ",
          "     ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝     ",
          "",
        },
        center = {
          { icon = "  ", desc = "Procurar arquivo", key = "f", action = "FzfLua files" },
          { icon = "  ", desc = "Arquivos recentes", key = "r", action = "FzfLua oldfiles" },
          { icon = "  ", desc = "Novo arquivo", key = "n", action = "enew | startinsert" },
          { icon = "󰦛  ", desc = "Restaurar sessão", key = "s", action = "lua require('persistence').select()" },
          {
            icon = "  ",
            desc = "Configuração do Neovim",
            key = "c",
            action = function()
              vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
            end,
          },
          { icon = "󰅚  ", desc = "Sair", key = "q", action = "quit" },
        },
        footer = { "Kanagawa Wave · Neovim " .. vim.version().major .. "." .. vim.version().minor },
      },
    },
  },
}

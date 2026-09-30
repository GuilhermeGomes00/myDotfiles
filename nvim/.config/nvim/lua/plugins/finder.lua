return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Procurar arquivo" },
      { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Procurar texto" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Palavra sob cursor" },
      { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Símbolos do arquivo" },
      { "<leader>fS", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "Símbolos do projeto" },
      { "<leader>fr", "<cmd>FzfLua lsp_references<CR>", desc = "Referências" },
      { "<leader>fc", "<cmd>FzfLua commands<CR>", desc = "Comandos" },
      { "<leader>fh", "<cmd>FzfLua helptags<CR>", desc = "Ajuda" },
      { "<leader>fo", "<cmd>FzfLua oldfiles<CR>", desc = "Histórico de arquivos" },
    },
    opts = {
      winopts = {
        height = 0.85,
        width = 0.88,
        row = 0.5,
        col = 0.5,
        border = "rounded",
        -- Let Ashen's Neovim highlight groups color the picker.
        backdrop = false,
        preview = { border = "rounded", layout = "flex" },
      },
      files = { formatter = "path.filename_first", git_icons = true, file_icons = true },
      grep = { formatter = "path.filename_first", git_icons = true, file_icons = true },
      fzf_colors = false,
    },
    config = function(_, opts)
      local fzf = require("fzf-lua")
      fzf.setup(opts)
      fzf.register_ui_select()
    end,
  },
}

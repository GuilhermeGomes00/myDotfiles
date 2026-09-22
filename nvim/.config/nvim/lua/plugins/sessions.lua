return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      need = 1,
      branch = true,
    },
    keys = {
      { "<leader>ss", function() require("persistence").load() end, desc = "Restaurar sessão do projeto" },
      { "<leader>sS", function() require("persistence").select() end, desc = "Selecionar sessão" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restaurar última sessão" },
      { "<leader>sd", function() require("persistence").stop() end, desc = "Não salvar esta sessão" },
    },
  },
}

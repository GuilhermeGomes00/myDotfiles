return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 350,
      spec = {
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Código" },
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "Buscar" },
        { "<leader>g", group = "Git" },
        { "<leader>n", group = "Novo" },
        { "<leader>nc", desc = "C#" },
        { "<leader>nj", desc = "Java" },
        { "<leader>nh", desc = "C" },
        { "<leader>s", group = "Sessão" },
        { "<leader>t", group = "Terminal/Testes" },
        { "<leader>x", group = "Diagnósticos" },
      },
    },
  },
}

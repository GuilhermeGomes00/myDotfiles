return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>j", function() require("flash").jump() end, desc = "Flash: buscar posição" },
      { "<leader>J", function() require("flash").treesitter() end, desc = "Flash: buscar nó Treesitter" },
    },
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select").select_textobject
      local move = require("nvim-treesitter-textobjects.move")
      local map = vim.keymap.set

      for _, object in ipairs({
        { "f", "function" },
        { "c", "class" },
        { "a", "parameter" },
      }) do
        local key, capture = object[1], object[2]
        map({ "x", "o" }, "a" .. key, function()
          select("@" .. capture .. ".outer", "textobjects")
        end, { desc = "Treesitter: ao redor de " .. capture })
        map({ "x", "o" }, "i" .. key, function()
          select("@" .. capture .. ".inner", "textobjects")
        end, { desc = "Treesitter: dentro de " .. capture })
      end

      map({ "n", "x", "o" }, "<leader>mf", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Treesitter: próxima função" })
      map({ "n", "x", "o" }, "<leader>mF", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Treesitter: função anterior" })
      map({ "n", "x", "o" }, "<leader>mc", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "Treesitter: próxima classe" })
      map({ "n", "x", "o" }, "<leader>mC", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "Treesitter: classe anterior" })
    end,
  },
}

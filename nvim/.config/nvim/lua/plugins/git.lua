return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      current_line_blame = false,
      preview_config = { border = "rounded" },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", function() gs.nav_hunk("next") end, "Próximo hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Hunk anterior")
        map({ "n", "x" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "x" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Alternar blame")
        map("n", "<leader>gd", gs.diffthis, "Diff do arquivo")
      end,
    },
  },
}

return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      focus = true,
      auto_close = false,
      warn_no_results = false,
      modes = {
        diagnostics = { auto_open = false, auto_close = false },
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnósticos do projeto" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnósticos do buffer" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Símbolos" },
      { "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>", desc = "Referências" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix" },
    },
    init = function()
      vim.diagnostic.config({
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
        virtual_text = {
          spacing = 2,
          source = "if_many",
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        float = { border = "rounded", source = "if_many", focusable = true },
      })
    end,
  },
}

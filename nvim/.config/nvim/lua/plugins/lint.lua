return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "ruff" },
        sh = { "shellcheck" },
        markdown = { "cspell" },
        text = { "cspell" },
      }

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
        callback = function()
          if vim.bo.modifiable and vim.bo.buftype == "" then
            lint.try_lint()
          end
        end,
      })

      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, { desc = "Executar linter do buffer" })
      vim.api.nvim_create_user_command("LintSpell", function()
        lint.try_lint("cspell")
      end, { desc = "Executar cspell manualmente" })
    end,
  },
}

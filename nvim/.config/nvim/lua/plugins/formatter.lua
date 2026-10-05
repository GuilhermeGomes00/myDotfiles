local format_filetypes = {
  c = true,
  cs = true,
  css = true,
  go = true,
  html = true,
  java = true,
  javascript = true,
  javascriptreact = true,
  json = true,
  jsonc = true,
  lua = true,
  markdown = true,
  python = true,
  sh = true,
  toml = true,
  typescript = true,
  typescriptreact = true,
  yaml = true,
}

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    -- :Format is created in init and loads Conform through require(). A Lazy
    -- command handler would delete it when the plugin finishes loading.
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "x" },
        desc = "Formatar",
      },
    },
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cs = { "csharpier" },
        css = { "prettier" },
        go = { "gofumpt" },
        html = { "prettier" },
        java = { "google-java-format" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "ruff_format" },
        sh = { "shfmt" },
        toml = { "taplo" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat or not format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        for _, formatter in ipairs(require("conform").list_formatters(bufnr)) do
          if formatter.available then
            return { timeout_ms = 1500, lsp_format = "fallback" }
          end
        end
      end,
      notify_on_error = true,
      notify_no_formatters = false,
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.api.nvim_create_user_command("Format", function(args)
        local range
        if args.range > 0 then
          local last = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1] or ""
          range = { start = { args.line1, 0 }, ["end"] = { args.line2, #last } }
        end
        require("conform").format({ async = true, lsp_format = "fallback", range = range })
      end, { range = true, desc = "Formatar buffer ou seleção" })
      vim.api.nvim_create_user_command("FormatToggle", function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        vim.notify("Format on save: " .. (vim.b.disable_autoformat and "desativado" or "ativado"))
      end, { desc = "Alternar format on save neste buffer" })
    end,
  },
}

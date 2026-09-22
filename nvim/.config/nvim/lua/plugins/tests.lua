return {
  {
    "nvim-neotest/neotest",
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Teste mais próximo" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Testar arquivo" },
      { "<leader>ta", function() require("neotest").run.run({ suite = true }) end, desc = "Testar suite/projeto" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debugar teste" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Resumo de testes" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Output do teste" },
      { "<leader>tp", function() require("neotest").output_panel.toggle() end, desc = "Painel de testes" },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap",
      "nsidorenco/neotest-vstest",
      { "fredrikaverpil/neotest-golang", version = "*" },
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-python",
      { "rcasia/neotest-java", ft = "java", dependencies = { "mfussenegger/nvim-jdtls" } },
    },
    config = function()
      vim.g.neotest_vstest = {
        broad_recursive_discovery = false,
        dap_settings = { type = "netcoredbg" },
      }
      require("neotest").setup({
        adapters = {
          require("neotest-vstest"),
          require("neotest-golang")({ dap_go_enabled = true }),
          require("neotest-jest")({}),
          require("neotest-vitest")({
            filter_dir = function(name)
              return name ~= "node_modules" and name ~= ".git" and name ~= "dist"
            end,
          }),
          require("neotest-python")({ runner = "pytest", dap = { justMyCode = false } }),
          require("neotest-java")({ incremental_build = true }),
        },
        output = { open_on_run = "short" },
        quickfix = { open = false },
        status = { virtual_text = false, signs = true },
        icons = { passed = "✓", running = "●", failed = "✗", skipped = "○", unknown = "?" },
      })
    end,
  },
}

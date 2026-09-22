local function executable(name)
  local path = vim.fn.exepath(name)
  return path ~= "" and path or name
end

local function python_for_debugpy()
  local mason_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
  return vim.uv.fs_stat(mason_python) and mason_python or executable("python")
end

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: iniciar/continuar" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Interface do debugger" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Encerrar debug" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Repetir debug" },
    },
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "theHamsta/nvim-dap-virtual-text",
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        layouts = {
          {
            elements = { { id = "scopes", size = 0.45 }, { id = "stacks", size = 0.3 }, { id = "watches", size = 0.25 } },
            position = "left",
            size = 42,
          },
          {
            elements = { { id = "repl", size = 0.55 }, { id = "console", size = 0.45 } },
            position = "bottom",
            size = 12,
          },
        },
        floating = { border = "rounded" },
      })
      require("nvim-dap-virtual-text").setup({ commented = true, only_first_definition = true })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      dap.adapters.netcoredbg = {
        type = "executable",
        command = executable("netcoredbg"),
        args = { "--interpreter=vscode" },
      }
      dap.configurations.cs = {
        {
          type = "netcoredbg",
          name = "Launch .NET assembly",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = function()
            return vim.fn.input("DLL do projeto: ", require("config.root").get(0) .. "/bin/Debug/", "file")
          end,
        },
        {
          type = "netcoredbg",
          name = "Attach .NET process",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }

      require("dap-go").setup({ delve = { path = executable("dlv") } })
      require("dap-python").setup(python_for_debugpy())

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = { command = executable("js-debug-adapter"), args = { "${port}" } },
      }
      local js_configurations = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch current file (Node)",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Node process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
      }
      for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
        dap.configurations[ft] = js_configurations
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = { command = executable("codelldb"), args = { "--port", "${port}" } },
      }
      dap.configurations.c = {
        {
          name = "Launch C executable",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executável: ", require("config.root").get(0) .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })
    end,
  },
}

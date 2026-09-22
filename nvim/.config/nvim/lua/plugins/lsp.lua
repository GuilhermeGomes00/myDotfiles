local servers = {
  "basedpyright",
  "bashls",
  "clangd",
  "cssls",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "taplo",
  "vtsls",
  "yamlls",
}

local function lsp_keymaps(args)
  local map = function(lhs, rhs, desc, mode)
    vim.keymap.set(mode or "n", lhs, rhs, { buffer = args.buf, desc = desc })
  end

  map("gd", vim.lsp.buf.definition, "LSP: definição")
  map("gD", vim.lsp.buf.declaration, "LSP: declaração")
  map("grr", vim.lsp.buf.references, "LSP: referências")
  map("gri", vim.lsp.buf.implementation, "LSP: implementação")
  map("K", vim.lsp.buf.hover, "LSP: documentação")
  map("<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
  map("<leader>ca", vim.lsp.buf.code_action, "Ação de código", { "n", "x" })
  map("[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, "Diagnóstico anterior")
  map("]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, "Próximo diagnóstico")
  map("<leader>cd", vim.diagnostic.open_float, "Diagnóstico da linha")
  map("<leader>ch", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = args.buf })
  end, "Alternar inlay hints")
end

return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {
      ui = { border = "rounded" },
      -- roslyn.nvim recommends this registry for the server version shipped
      -- with VS Code; the core Mason package currently lags its minimum.
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = lsp_keymaps,
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = { unusedparams = true, unusedwrite = true, useany = true },
          },
        },
      })

      vim.lsp.config("vtsls", {
        settings = {
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = {
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
          },
        },
      })

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "standard",
            },
            disableTaggedHints = true,
          },
        },
      })

      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
      })

      vim.lsp.config("lua_ls", {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
              return
            end
          end
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
            runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          })
        end,
        settings = { Lua = {} },
      })

      vim.lsp.config("yamlls", {
        settings = { yaml = { keyOrdering = false, format = { enable = true } } },
      })

      vim.lsp.enable(servers)
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = vim.list_extend(vim.deepcopy(servers), { "jdtls" }),
      automatic_enable = false,
    },
  },
}

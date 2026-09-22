return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "c_sharp",
        "c",
        "go",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "java",
        "lua",
        "json",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "bash",
        "yaml",
        "toml",
      }

      -- O parser JSON atual também cobre JSON com comentários. O catálogo da
      -- API nova não publica um parser separado chamado "jsonc".
      vim.treesitter.language.register("json", "jsonc")

      require("nvim-treesitter").install(parsers)

      local filetypes = {
        "cs",
        "c",
        "go",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "python",
        "java",
        "lua",
        "json",
        "jsonc",
        "html",
        "css",
        "markdown",
        "bash",
        "yaml",
        "toml",
      }
      local reliable_indent = {
        c = true,
        cs = true,
        go = true,
        java = true,
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
        lua = true,
        json = true,
        jsonc = true,
        html = true,
        css = true,
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          if reliable_indent[vim.bo[args.buf].filetype] then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}

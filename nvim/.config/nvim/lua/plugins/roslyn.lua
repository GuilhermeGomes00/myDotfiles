return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor", "cshtml" },
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      broad_search = true,
      filewatching = "roslyn",
      lock_target = false,
    },
    config = function(_, opts)
      vim.lsp.config("roslyn", {
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          },
        },
      })
      require("roslyn").setup(opts)
    end,
  },
}

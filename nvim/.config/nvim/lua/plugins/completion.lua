return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    lazy = false,
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = {
          "select_next",
          "snippet_forward",
          function()
            -- Let Blink handle its own completion UI first. If it has nothing
            -- to do, run tabout's Plug mapping without replacing Blink's map.
            if vim.fn.maparg("<Plug>(Tabout)", "i") == "" then
              return false
            end
            local termcodes = vim.api.nvim_replace_termcodes("<Plug>(Tabout)", true, true, true)
            vim.api.nvim_feedkeys(termcodes, "m", false)
            return true
          end,
          "fallback",
        },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
          window = { border = "rounded" },
        },
        menu = {
          border = "rounded",
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },
        list = { selection = { preselect = false, auto_insert = false } },
      },
      snippets = { preset = "default" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      signature = { enabled = true, window = { border = "rounded" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = false,
      disable_filetype = { "TelescopePrompt", "snacks_picker_input" },
    },
  },
}

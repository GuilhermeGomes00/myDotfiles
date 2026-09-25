return {
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      -- Blink owns <Tab>/<S-Tab>; completion.lua calls this plugin's Plug map
      -- only after completion and snippet actions have declined the key.
      tabkey = "",
      backwards_tabkey = "",
      completion = true,
      act_as_tab = true,
      act_as_shift_tab = false,
      enable_backwards = false,
      ignore_beginning = true,
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
      },
    },
  },
}

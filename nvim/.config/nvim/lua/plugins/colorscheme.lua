return {
  {
    "ficcdaf/ashen.nvim",
    version = "*",
    lazy = false,
    priority = 1000,
    opts = {
      -- Keep the transparent editor background already used by this config.
      transparent = true,
    },
    config = function(_, opts)
      require("ashen").setup(opts)
      vim.cmd("colorscheme ashen")
    end,
  },
}

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "dark",
      },
      on_highlights = function(highlights, colors)
        highlights.NormalFloat = { bg = colors.bg_float }
        highlights.FloatBorder = { fg = colors.blue, bg = colors.bg_float }
        highlights.FloatTitle = { fg = colors.blue, bg = colors.bg_float, bold = true }
        highlights.Pmenu = { fg = colors.fg, bg = colors.bg_float }
        highlights.PmenuSel = { fg = colors.fg, bg = colors.bg_highlight }
        highlights.PmenuSbar = { bg = colors.bg_dark }
        highlights.PmenuThumb = { bg = colors.bg_highlight }
        highlights.NvimTreeNormal = { bg = "none" }
        highlights.NvimTreeNormalNC = { bg = "none" }
        highlights.NvimTreeEndOfBuffer = { bg = "none" }
        highlights.LazyNormal = { fg = colors.fg_dark, bg = colors.bg_float }
        highlights.MasonNormal = { fg = colors.fg_dark, bg = colors.bg_float }
        highlights.NoiceCmdlinePopup = { fg = colors.fg, bg = colors.bg_float }
        highlights.NoiceCmdlinePopupBorder = { fg = colors.blue, bg = colors.bg_float }
        highlights.NoiceCmdlinePopupBorderSearch = { fg = colors.orange, bg = colors.bg_float }
        highlights.NoiceCmdlinePopupTitle = { fg = colors.blue, bg = colors.bg_float, bold = true }
        highlights.NoiceCmdlineIcon = { fg = colors.blue, bg = colors.bg_float }
        highlights.NoiceCmdlineIconSearch = { fg = colors.orange, bg = colors.bg_float }
        highlights.NoiceCursor = { fg = colors.bg_float, bg = colors.blue }
        highlights.NoicePopupmenu = { fg = colors.fg, bg = colors.bg_float }
        highlights.NoicePopupmenuBorder = { fg = colors.blue, bg = colors.bg_float }
        highlights.NoicePopupmenuMatch = { fg = colors.blue, bg = colors.bg_float, bold = true }
        highlights.NoicePopupmenuSelected = { fg = colors.fg, bg = colors.bg_highlight }
        highlights.FzfLuaNormal = { fg = colors.fg, bg = colors.bg_float }
        highlights.FzfLuaBorder = { fg = colors.blue, bg = colors.bg_float }
        highlights.FzfLuaTitle = { fg = colors.blue, bg = colors.bg_float, bold = true }
        highlights.FzfLuaPreviewNormal = { fg = colors.fg, bg = colors.bg_float }
        highlights.FzfLuaPreviewBorder = { fg = colors.blue, bg = colors.bg_float }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}

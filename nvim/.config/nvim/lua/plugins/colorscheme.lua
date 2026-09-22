return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      undercurl = true,
      transparent = true,
      dimInactive = false,
      terminalColors = true,
      theme = "wave",
      background = { dark = "wave", light = "lotus" },
      colors = {
        theme = { all = { ui = { bg_gutter = "none" } } },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { fg = theme.ui.float.fg_border, bg = "none" },
          FloatTitle = { fg = theme.ui.special, bg = "none", bold = true },
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
          NvimTreeNormal = { bg = "none" },
          NvimTreeNormalNC = { bg = "none" },
          NvimTreeEndOfBuffer = { bg = "none" },
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          -- Keep the command/search UI opaque even though other floats are transparent.
          NoiceCmdlinePopup = { fg = theme.ui.fg, bg = theme.ui.bg_m3 },
          NoiceCmdlinePopupBorder = { fg = theme.ui.special, bg = theme.ui.bg_m3 },
          NoiceCmdlinePopupBorderSearch = { fg = theme.diag.warning, bg = theme.ui.bg_m3 },
          NoiceCmdlinePopupTitle = { fg = theme.ui.special, bg = theme.ui.bg_m3, bold = true },
          NoiceCmdlineIcon = { fg = theme.ui.special, bg = theme.ui.bg_m3 },
          NoiceCmdlineIconSearch = { fg = theme.diag.warning, bg = theme.ui.bg_m3 },
          NoiceCursor = { fg = theme.ui.bg_m3, bg = theme.ui.special },
          NoicePopupmenu = { fg = theme.ui.fg, bg = theme.ui.bg_m3 },
          NoicePopupmenuBorder = { fg = theme.ui.special, bg = theme.ui.bg_m3 },
          NoicePopupmenuMatch = { fg = theme.syn.fun, bg = theme.ui.bg_m3, bold = true },
          NoicePopupmenuSelected = { fg = theme.ui.fg, bg = theme.ui.bg_p2 },
          -- FzfLua owns its float independently of Noice, so give it the same solid palette.
          FzfLuaNormal = { fg = theme.ui.fg, bg = theme.ui.bg_m3 },
          FzfLuaBorder = { fg = theme.ui.special, bg = theme.ui.bg_m3 },
          FzfLuaTitle = { fg = theme.ui.special, bg = theme.ui.bg_m3, bold = true },
          FzfLuaPreviewNormal = { fg = theme.ui.fg, bg = theme.ui.bg_m3 },
          FzfLuaPreviewBorder = { fg = theme.ui.special, bg = theme.ui.bg_m3 },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },
}

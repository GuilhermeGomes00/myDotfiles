return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        icons_enabled = true,
        theme = "kanagawa",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "dashboard" } },
      },
      sections = {
        lualine_a = { { "mode", fmt = function(value) return value:sub(1, 1) end } },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1, symbols = { modified = " ●", readonly = " " } } },
        lualine_x = {
          "diagnostics",
          "filetype",
          {
            function()
              local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
              return encoding ~= "utf-8" and encoding or ""
            end,
          },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
      },
      extensions = { "nvim-tree", "trouble", "lazy", "mason", "nvim-dap-ui", "fzf" },
    },
  },
}

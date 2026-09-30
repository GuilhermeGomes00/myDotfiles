return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "ficcdaf/ashen.nvim" },
    opts = function()
      local ashen = require("ashen.plugins.lualine").lualine_opts

      ashen.options = vim.tbl_deep_extend("force", ashen.options or {}, {
        icons_enabled = true,
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "dashboard" } },
      })
      ashen.sections = {
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
      }
      ashen.inactive_sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
      }
      ashen.extensions = { "nvim-tree", "trouble", "lazy", "mason", "nvim-dap-ui", "fzf" }
      return ashen
    end,
  },
}

local c = require("config.palette")

return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons", "ficcdaf/ashen.nvim" },
		opts = function()
			local ashen = vim.deepcopy(require("ashen.plugins.lualine").lualine_opts)

			ashen.options = vim.tbl_deep_extend("force", ashen.options or {}, {
				icons_enabled = true,
				globalstatus = true,
				theme = {
					normal = {
						a = { fg = c.selected, bg = "NONE", gui = "bold" },
						b = { fg = c.light_gray, bg = "NONE" },
						c = { fg = c.white, bg = "NONE" },
					},
					insert = { a = { fg = c.red, bg = "NONE", gui = "bold" } },
					visual = { a = { fg = c.orange, bg = "NONE", gui = "bold" } },
					replace = { a = { fg = c.dark_red, bg = "NONE", gui = "bold" } },
					command = { a = { fg = c.orange, bg = "NONE", gui = "bold" } },
					terminal = { a = { fg = c.icon, bg = "NONE", gui = "bold" } },
					inactive = {
						a = { fg = c.gray, bg = "NONE" },
						b = { fg = c.gray, bg = "NONE" },
						c = { fg = c.gray, bg = "NONE" },
					},
				},
				component_separators = { left = "│", right = "│" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { statusline = { "dashboard" } },
			})
			ashen.sections = {
				lualine_a = { {
					"mode",
					fmt = function(value)
						return value:sub(1, 1)
					end,
				} },
				lualine_b = {
					"branch",
					{
						"diff",
						diff_color = {
							added = { fg = c.light_gray },
							modified = { fg = c.orange },
							removed = { fg = c.dark_red },
						},
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = { modified = " ●", readonly = " " },
						color = function()
							local errors = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
							return { fg = #errors > 0 and c.error or c.selected }
						end,
					},
				},
				lualine_x = {
					{
						"diagnostics",
						diagnostics_color = {
							error = { fg = c.error },
							warn = { fg = c.warning },
							info = { fg = c.light_gray },
							hint = { fg = c.dark_gray },
						},
					},
					{ "filetype", icon_color = c.icon },
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

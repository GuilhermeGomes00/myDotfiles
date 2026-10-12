local palette = require("config.palette")

return {
	{
		"ficcdaf/ashen.nvim",
		version = "*",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = false,
			hl = { merge_override = require("config.highlights") },
			terminal = {
				colors = {
					[0] = palette.background,
					palette.dark_red,
					palette.light_gray,
					palette.orange,
					palette.error,
					palette.dark_orange,
					palette.gray,
					palette.white,
					palette.dark_gray,
					palette.red,
					palette.white,
					palette.warning,
					palette.error,
					palette.icon,
					palette.light_gray,
					palette.white,
				},
			},
		},
		config = function(_, opts)
			-- O Ashen e alguns plugins definem links após seus overrides.
			-- Aplica a paleta ao fim do evento para manter a cor e a transparência.
			local function apply(only_lsp)
				if vim.g.colors_name ~= "ashen" then
					return
				end
				for name, definition in pairs(opts.hl.merge_override) do
					if not only_lsp or name:match("^@lsp%.") then
						vim.api.nvim_set_hl(0, name, definition)
					end
				end
			end
			local group = vim.api.nvim_create_augroup("SharedPalette", { clear = true })
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = group,
				pattern = "ashen",
				callback = function()
					apply(false)
				end,
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = group,
				callback = function()
					vim.schedule(function()
						apply(true)
					end)
				end,
			})
			require("ashen").setup(opts)
			vim.cmd("colorscheme ashen")
		end,
	},
}

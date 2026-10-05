local c = require("config.palette")

return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			highlights = (function()
				local h = {}
				for _, name in ipairs({
					"fill",
					"background",
					"buffer_visible",
					"numbers",
					"numbers_visible",
					"separator",
					"separator_visible",
					"separator_selected",
					"tab_separator",
					"tab_separator_selected",
					"tab",
					"tab_close",
					"close_button",
					"close_button_visible",
				}) do
					h[name] = { fg = c.gray, bg = "NONE" }
				end
				for _, name in ipairs({
					"buffer_selected",
					"numbers_selected",
					"tab_selected",
					"close_button_selected",
					"indicator_selected",
					"indicator_visible",
				}) do
					h[name] = { fg = c.selected, bg = "NONE", bold = true, italic = false }
				end
				for severity, color in pairs({
					error = c.error,
					warning = c.warning,
					info = c.light_gray,
					hint = c.dark_gray,
				}) do
					for _, suffix in ipairs({ "", "_visible", "_selected" }) do
						h[severity .. suffix] = { fg = color, bg = "NONE" }
						h[severity .. "_diagnostic" .. suffix] = { fg = color, bg = "NONE" }
					end
				end
				for _, name in ipairs({ "modified", "modified_visible", "modified_selected" }) do
					h[name] = { fg = c.orange, bg = "NONE" }
				end
				return h
			end)(),
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp",
				color_icons = true,
				indicator = { style = "none" },
				always_show_bufferline = true,
				-- Keep unsaved changes protected when closing a buffer with the mouse.
				close_command = "bdelete %d",
				right_mouse_command = "bdelete %d",
				offsets = {
					{ filetype = "NvimTree", text = "Explorer", text_align = "center", separator = true },
				},
			},
		},
	},
}

local CMDLINE_ROW = 3
local POPUPMENU_ROW = 6
local CMDLINE_MIN_WIDTH = 58
local CMDLINE_MAX_WIDTH = 68

local function width_limits()
	local max_width = math.min(CMDLINE_MAX_WIDTH, math.max(20, vim.o.columns - 4))
	return math.min(CMDLINE_MIN_WIDTH, max_width), max_width
end

return {
	{
		"folke/noice.nvim",
		-- The cmdline UI must be attached before the first interactive prompt.
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		init = function()
			local group = vim.api.nvim_create_augroup("NoiceCmdlineResize", { clear = true })
			vim.api.nvim_create_autocmd("VimResized", {
				group = group,
				callback = function()
					local ok, config = pcall(require, "noice.config")
					if not ok or not config.is_running() then
						return
					end

					local min_width, max_width = width_limits()
					for _, view in ipairs({ "cmdline_popup", "cmdline_popupmenu" }) do
						config.options.views[view].size.min_width = min_width
						config.options.views[view].size.max_width = max_width
					end
				end,
			})
		end,
		opts = function()
			local min_width, max_width = width_limits()
			return {
				cmdline = {
					enabled = true,
					view = "cmdline_popup",
					format = {
						-- Keep the prompt character visible beside the icon.
						cmdline = { pattern = "^:", icon = " ", lang = "vim", conceal = false },
						search_down = {
							kind = "search",
							pattern = "^/",
							icon = " ",
							lang = "regex",
							conceal = false,
						},
						search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex", conceal = false },
						filter = { pattern = "^:%s*!", icon = " ", lang = "bash", conceal = false },
						lua = {
							pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
							icon = " ",
							lang = "lua",
						},
						help = { pattern = "^:%s*he?l?p?%s+", icon = "󰘥 ", conceal = false },
						input = { view = "cmdline_input", icon = "󰥻 " },
					},
				},
				messages = {
					enabled = true,
					-- This controls the separate search-count message, not the / and ? input.
					-- Disable it to keep the top cmdline as the only search UI.
					view_search = false,
				},
				popupmenu = {
					enabled = true,
					backend = "nui",
				},
				lsp = {
					hover = { enabled = true },
					-- Blink already owns signature help and is configured with a rounded window.
					signature = { enabled = false },
				},
				presets = {
					bottom_search = false,
					command_palette = false,
					lsp_doc_border = true,
					long_message_to_split = true,
				},
				views = {
					cmdline_popup = {
						position = { row = CMDLINE_ROW, col = "50%" },
						size = { min_width = min_width, max_width = max_width, width = "auto", height = "auto" },
						border = { style = "rounded", padding = { 0, 2 } },
						win_options = {
							winhighlight = {
								Normal = "NoiceCmdlinePopup",
								FloatBorder = "NoiceCmdlinePopupBorder",
								FloatTitle = "NoiceCmdlinePopupTitle",
								IncSearch = "",
								CurSearch = "",
								Search = "",
							},
						},
					},
					cmdline_input = {
						view = "cmdline_popup",
					},
					-- Explicit coordinates keep cmdline completion directly below the input.
					cmdline_popupmenu = {
						relative = "editor",
						position = { row = POPUPMENU_ROW, col = "50%" },
						size = {
							min_width = min_width,
							max_width = max_width,
							width = "auto",
							height = "auto",
							max_height = 12,
						},
						border = { style = "rounded", padding = { 0, 1 } },
						win_options = {
							winhighlight = {
								Normal = "NoicePopupmenu",
								FloatBorder = "NoicePopupmenuBorder",
								CursorLine = "NoicePopupmenuSelected",
								PmenuMatch = "NoicePopupmenuMatch",
							},
						},
					},
				},
			}
		end,
	},
}

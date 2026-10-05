local function toggle_explorer()
	local api = require("nvim-tree.api")
	if api.tree.is_visible() then
		if vim.bo.filetype == "NvimTree" then
			api.tree.close()
		else
			api.tree.focus()
		end
	else
		api.tree.open({ find_file = true, focus = true })
	end
end

local function setup_selection(api)
	local namespace = vim.api.nvim_create_namespace("NvimTreeSelectedName")
	local highlights = vim.api.nvim_create_namespace("NvimTreeHighlights")
	local function update(bufnr, winid)
		if not winid or not vim.api.nvim_win_is_valid(winid) or not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end
		vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
		vim.api.nvim_win_call(winid, function()
			local node = api.tree.get_node_under_cursor()
			-- O diagnóstico azul tem prioridade sobre a seleção laranja.
			if not node or not node.parent or node.diag_severity == vim.diagnostic.severity.ERROR then
				return
			end
			local filebuf = vim.fn.bufnr(node.absolute_path)
			if filebuf > 0 and #vim.diagnostic.get(filebuf, { severity = vim.diagnostic.severity.ERROR }) > 0 then
				return
			end
			local row = vim.api.nvim_win_get_cursor(winid)[1] - 1
			local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
			local first, last = line:find(node.name, 1, true)
			if not first then
				return
			end
			local start_col, end_col = first - 1, last
			-- Usa o intervalo do nome renderizado, incluindo pastas agrupadas.
			for _, mark in
				ipairs(vim.api.nvim_buf_get_extmarks(bufnr, highlights, { row, 0 }, { row, -1 }, { details = true }))
			do
				local details = mark[4]
				if details.end_row == row and mark[3] <= start_col and details.end_col >= end_col then
					start_col, end_col = mark[3], details.end_col
				end
			end
			vim.api.nvim_buf_set_extmark(bufnr, namespace, row, start_col, {
				end_col = end_col,
				hl_group = "NvimTreeSelectedName",
				priority = vim.hl.priorities.user,
			})
		end)
	end
	vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
		group = vim.api.nvim_create_augroup("NvimTreeSelectedName", { clear = true }),
		pattern = "NvimTree_*",
		callback = function(args)
			update(args.buf, vim.api.nvim_get_current_win())
		end,
	})
	api.events.subscribe(api.events.Event.TreeRendered, function(args)
		update(args.bufnr, args.winnr)
	end)
end

return {
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = { variant = "dark" },
		config = function(_, opts)
			local devicons = require("nvim-web-devicons")
			devicons.setup(opts)
			local icons = vim.deepcopy(devicons.get_icons())
			for _, icon in pairs(icons) do
				icon.color = require("config.palette").icon
				icon.cterm_color = "202"
			end
			devicons.set_icon(icons)
			devicons.set_default_icon("", require("config.palette").icon, "202")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
		keys = {
			{ "<leader>e", toggle_explorer, desc = "Explorer" },
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function(_, opts)
			local api = require("nvim-tree.api")
			setup_selection(api)
			require("nvim-tree").setup(opts)
		end,
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			local function open_project_tree()
				if vim.g.started_with_directory then
					vim.schedule(function()
						require("nvim-tree.api").tree.open({ find_file = true, focus = false })
					end)
				end
			end

			-- Scheduling from the spec init works whether Lazy imports it just before
			-- or during VimEnter and keeps `nvim .` deterministic.
			open_project_tree()
		end,
		opts = {
			-- netrw is disabled in init, so its FileExplorer group does not exist.
			hijack_netrw = false,
			sync_root_with_cwd = true,
			respect_buf_cwd = true,
			update_focused_file = { enable = true, update_root = false },
			view = {
				side = "right",
				width = 30,
				preserve_window_proportions = true,
				signcolumn = "yes",
			},
			renderer = {
				group_empty = true,
				highlight_git = "name",
				highlight_diagnostics = "name",
				-- As cores compartilhadas são definidas em config/highlights.lua.
				highlight_opened_files = "name",
				highlight_hidden = "name", -- Dotfiles aparecem ao alternar o filtro com H.
				highlight_modified = "name", -- Buffers modificados, ainda não salvos.
				icons = {
					-- Mantém os glifos do devicons, mas usa NvimTreeFileIcon para a cor.
					-- Isso afeta só este explorer; outros plugins mantêm as cores do devicons.
					web_devicons = { file = { color = false } },
					git_placement = "after",
					show = { file = true, folder = true, folder_arrow = true, git = true, modified = true },
					glyphs = {
						git = {
							unstaged = "M",
							staged = "S",
							unmerged = "U",
							renamed = "R",
							untracked = "?",
							deleted = "D",
							ignored = "I",
						},
					},
				},
			},
			filters = { dotfiles = true, git_ignored = false },
			-- Necessário para os grupos NvimTreeModified* e para o marcador de modificação.
			modified = { enable = true },
			git = { enable = true, ignore = false, show_on_dirs = true, timeout = 400 },
			diagnostics = { enable = true, show_on_dirs = true },
			filesystem_watchers = { enable = true },
			actions = {
				open_file = {
					quit_on_open = false,
					resize_window = true,
					window_picker = { enable = true, exclude = { filetype = { "NvimTree", "notify" } } },
				},
			},
		},
	},
}

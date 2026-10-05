return {
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = true,
			colors = {
				error = { require("config.palette").error },
				warning = { require("config.palette").warning },
				info = { require("config.palette").light_gray },
				hint = { require("config.palette").dark_gray },
				default = { require("config.palette").orange },
			},
			highlight = { before = "", keyword = "fg", after = "" },
			keywords = {
				FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT" } },
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
				PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			},
		},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Próximo TODO",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "TODO anterior",
			},
			{ "<leader>ft", "<cmd>TodoFzfLua<CR>", desc = "Procurar TODOs" },
			{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "TODOs no Trouble" },
		},
	},
}

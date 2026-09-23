return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			latex = { enabled = false },
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)

			local function set_toggle(bufnr)
				vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown buf_toggle<CR>", {
					buffer = bufnr,
					desc = "Alternar renderização do Markdown",
				})
			end

			local current = vim.api.nvim_get_current_buf()
			if vim.bo[current].filetype == "markdown" then
				set_toggle(current)
			end
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserRenderMarkdown", { clear = true }),
				pattern = "markdown",
				callback = function(args)
					set_toggle(args.buf)
				end,
			})
		end,
	},
}

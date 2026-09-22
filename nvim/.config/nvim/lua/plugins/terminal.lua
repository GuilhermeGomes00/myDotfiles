local function terminal()
	Snacks.terminal.toggle(vim.o.shell, {
		cwd = require("config.root").get(0),
		win = {
			position = "float",
			width = 0.86,
			height = 0.84,
			border = "rounded",
			title = " Terminal ",
			title_pos = "center",
		},
	})
end

local function lazygit()
	if vim.fn.executable("lazygit") ~= 1 then
		vim.notify("lazygit não está instalado (Arch: sudo pacman -S lazygit)", vim.log.levels.WARN)
		return
	end
	Snacks.terminal.toggle("lazygit", {
		cwd = require("config.root").get(0),
		win = { position = "float", width = 0.92, height = 0.9, border = "rounded", title = " LazyGit " },
	})
end

return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = { terminal = {} },
		keys = {
			{ "<C-'>", terminal, desc = "Terminal flutuante", mode = { "n", "t" } },
			{ "<C-/>", terminal, desc = "Terminal flutuante", mode = { "n", "t" } },
			{ "<C-_>", terminal, desc = "Terminal flutuante", mode = { "n", "t" } },
			{ "<leader>gg", lazygit, desc = "LazyGit" },
			{ "<Esc><Esc>", "<C-\\><C-n>", mode = "t", desc = "Sair do modo terminal" },
		},
	},
}

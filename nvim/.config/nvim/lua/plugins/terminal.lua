local function terminal()
	local terminal_info = vim.b.snacks_terminal
	local cwd = terminal_info and terminal_info.cwd or require("config.root").get(0)
	Snacks.terminal.toggle(nil, {
		cwd = cwd,
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
		opts = {
			terminal = {},

			-- ============================================================
			-- INDENTAÇÃO / INDENT GUIDES
			-- ============================================================
			indent = {
				enabled = true,
				indent = {
					enabled = true,

					-- Caractere das guias normais de indentação.
					-- Troque ":" aqui se quiser outro símbolo no futuro.
					char = ".",

					-- false = mostra todos os níveis de indentação.
					only_scope = false,

					-- false = funciona em todas as janelas normais.
					only_current = false,
				},
				scope = {
					enabled = true,

					-- Caractere que destaca o scope atual detectado pelo
					-- Tree-sitter/indentação. Troque ":" aqui para alterá-lo.
					char = ":",

					-- Não desenhar underline no começo do scope.
					underline = false,
					only_current = false,

					-- Nesta versão, indent.scope aceita as opções de Snacks.scope.
					-- Usa Tree-sitter disponível e fallback para indentação,
					-- mantendo a detecção oficial sem forçar uma lista de nodes.
					treesitter = { enabled = true },
				},

				-- Desativado para usar apenas ":", sem desenhos ┌ └ │ de chunks.
				chunk = { enabled = false },

				-- Mantém o filtro padrão que exclui buffers especiais de interfaces.
				-- Mantém também os highlights padrão SnacksIndent/SnacksIndentScope.
			},
		},
		keys = {
			{ "<leader>tt", terminal, desc = "Terminal flutuante" },
			{ "<C-'>", terminal, desc = "Terminal flutuante", mode = { "n", "t" } },
			{ "<C-/>", terminal, desc = "Terminal flutuante", mode = { "n", "t" } },
			{ "<C-_>", terminal, desc = "Terminal flutuante", mode = { "n", "t" } },
			{ "<leader>gg", lazygit, desc = "LazyGit" },
			{ "<Esc><Esc>", "<C-\\><C-n>", mode = "t", desc = "Sair do modo terminal" },
		},
	},
}

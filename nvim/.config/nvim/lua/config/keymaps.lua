local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpar destaque da busca" })
map("n", "<C-h>", "<C-w>h", { desc = "Janela à esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Janela à direita" })
map("n", "H", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "L", "<cmd>bnext<CR>", { desc = "Próximo buffer" })
map("v", "<", "<gv", { desc = "Diminuir recuo" })
map("v", ">", ">gv", { desc = "Aumentar recuo" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Salvar arquivo" })

local function delete_buffer()
	local current = vim.api.nvim_get_current_buf()
	if vim.bo[current].modified then
		local choice =
			vim.fn.confirm("Salvar alterações antes de fechar o buffer?", "&Salvar\n&Descartar\n&Cancelar", 1)
		if choice == 1 then
			local ok = pcall(vim.cmd.write)
			if not ok then
				return
			end
		elseif choice ~= 2 then
			return
		end
	end

	local replacement
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if bufnr ~= current and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
			replacement = bufnr
			break
		end
	end

	if replacement then
		vim.api.nvim_set_current_buf(replacement)
	else
		vim.cmd.enew()
	end
	pcall(vim.api.nvim_buf_delete, current, { force = true })
end

map("n", "<leader>bd", delete_buffer, { desc = "Fechar buffer" })
map("n", "<leader>q", delete_buffer, { desc = "Fechar buffer" })

map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Fechar Neovim" })

local function new_file()
	local base = require("config.root").buffer_dir(0)
	vim.ui.input({ prompt = "Novo arquivo (relativo a " .. base .. "): " }, function(input)
		if not input or vim.trim(input) == "" then
			return
		end
		local path = vim.startswith(input, "/") and vim.fs.normalize(input) or vim.fs.joinpath(base, input)
		vim.fn.mkdir(vim.fs.dirname(path), "p")
		vim.cmd.edit(vim.fn.fnameescape(path))
	end)
end

map("n", "<leader>nf", new_file, { desc = "Novo arquivo" })
map("n", "<leader>nc", function()
	require("config.csharp_templates").select()
end, { desc = "Novo tipo C#" })
map("n", "<leader>nj", function()
	require("config.file_templates").java()
end, { desc = "Novo arquivo Java" })
map("n", "<leader>nh", function()
	require("config.file_templates").c()
end, { desc = "Novo arquivo C" })

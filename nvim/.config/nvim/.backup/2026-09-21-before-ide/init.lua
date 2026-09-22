-- Se o Neovim foi aberto com uma pasta, ex: `nvim .`
if vim.fn.argc() == 1 then
    local arg = vim.fn.argv(0)

    if vim.fn.isdirectory(arg) == 1 then
        local dir = vim.fn.fnamemodify(arg, ":p")

        -- Entra na pasta passada
        vim.cmd("cd " .. vim.fn.fnameescape(dir))

        -- Remove a pasta da lista de arquivos a serem abertos
        vim.cmd("%argdelete")
    end
end

require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.terminal")

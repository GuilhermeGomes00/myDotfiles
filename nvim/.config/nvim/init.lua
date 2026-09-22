vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Treat `nvim .` as a project launch, without leaving a directory buffer behind.
if vim.fn.argc(-1) == 1 then
  local argument = vim.fn.argv(0)
  if vim.fn.isdirectory(argument) == 1 then
    local directory = vim.fs.normalize(vim.fn.fnamemodify(argument, ":p"))
    vim.cmd.cd(vim.fn.fnameescape(directory))
    vim.cmd("silent! %argdelete")
    vim.g.started_with_directory = true
  end
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

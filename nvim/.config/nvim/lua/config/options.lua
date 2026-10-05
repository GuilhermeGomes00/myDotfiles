local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.background = "dark"
opt.clipboard = "unnamedplus"

opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = true
opt.breakindent = true

opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.timeoutlen = 400
opt.updatetime = 250
opt.mouse = "a"
opt.confirm = true

opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = true

opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 12
opt.winborder = "rounded"
opt.laststatus = 3
opt.showmode = false
opt.showtabline = 2
opt.cmdheight = 1
opt.shortmess:append("I")
opt.splitkeep = "screen"
opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "winpos",
  "terminal",
  "localoptions",
}

-- Keep indentation predictable while allowing language ftplugins to specialize it.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "html", "css", "yaml" },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
})

local group = vim.api.nvim_create_augroup("UserQualityOfLife", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 180 })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = group,
  command = "checktime",
})

local function markdown_enter()
  local blink = require("blink.cmp")
  if blink.is_menu_visible() and blink.accept() then
    return ""
  end

  local line = vim.api.nvim_get_current_line()
  local indent, marker, separator, spacing, body = line:match("^([ \t]*)(%d+)([.)])([ \t]+)(.*)$")
  local continuation

  if indent and vim.trim(body) ~= "" then
    continuation = indent .. (tonumber(marker) + 1) .. separator .. spacing
  else
    indent, marker, spacing, body = line:match("^([ \t]*)([-+*])([ \t]+)(.*)$")
    if indent and vim.trim(body) ~= "" then
      continuation = indent .. marker .. spacing
    end
  end

  if continuation then
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    vim.api.nvim_buf_set_text(0, row, col, row, col, { "", continuation })
    vim.api.nvim_win_set_cursor(0, { row + 2, #continuation })
    return
  end

  -- Keep the existing paired-character Enter behavior for non-list lines.
  vim.api.nvim_feedkeys(require("nvim-autopairs").completion_confirm(), "n", false)
end

local trim_filetypes = {
  c = true,
  cs = true,
  go = true,
  java = true,
  javascript = true,
  javascriptreact = true,
  json = true,
  jsonc = true,
  lua = true,
  python = true,
  typescript = true,
  typescriptreact = true,
  yaml = true,
  toml = true,
}

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function(args)
    if not trim_filetypes[vim.bo[args.buf].filetype] or not vim.bo[args.buf].modifiable then
      return
    end
    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_call(args.buf, function()
      vim.cmd([[silent! keepjumps keeppatterns %s/\s\+$//e]])
    end)
    vim.fn.winrestview(view)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    -- Restore these local settings when the buffer changes filetype.
    vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. " | setlocal spell< spelllang< wrap<"
    vim.opt_local.spell = true
    local has_portuguese = #vim.api.nvim_get_runtime_file("spell/pt.utf-8.spl", false) > 0
    vim.opt_local.spelllang = has_portuguese and { "pt_br", "en_us" } or { "en_us" }
    vim.opt_local.wrap = true
    if vim.bo.filetype == "markdown" then
      -- The Enter mapping below handles lists without `formatoptions` duplicating them.
      vim.opt_local.formatoptions:remove("r")
      vim.keymap.set("i", "<CR>", markdown_enter, {
        buffer = vim.api.nvim_get_current_buf(),
        desc = "Continuar lista Markdown",
      })
      vim.b.undo_ftplugin = vim.b.undo_ftplugin .. " | silent! iunmap <buffer> <CR>"
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

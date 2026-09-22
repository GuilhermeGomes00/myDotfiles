local M = {}

local function identifier(value)
  value = value:gsub("[^%w_]", "_")
  if value:match("^%d") then
    value = "_" .. value
  end
  return value
end

function M.destination_dir()
  if vim.bo.filetype == "NvimTree" then
    local ok, node = pcall(require("nvim-tree.api").tree.get_node_under_cursor)
    if ok and node and node.absolute_path then
      return node.type == "directory" and node.absolute_path or vim.fs.dirname(node.absolute_path)
    end
  end
  return require("config.root").buffer_dir(0)
end

function M.create(path, lines, cursor)
  if vim.uv.fs_stat(path) and vim.fn.confirm("Sobrescrever " .. path .. "?", "&Sim\n&Não", 2) ~= 1 then
    return false
  end

  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local ok, result = pcall(vim.fn.writefile, lines, path)
  if not ok or result == -1 then
    local reason = ok and "erro de escrita" or result
    vim.notify("Não foi possível criar " .. path .. ": " .. reason, vim.log.levels.ERROR)
    return false
  end

  vim.cmd.edit(vim.fn.fnameescape(path))
  if cursor then
    vim.api.nvim_win_set_cursor(0, cursor)
  end
  vim.notify("Criado: " .. path, vim.log.levels.INFO)
  return true
end

local function package_for(dir)
  local normalized = vim.fs.normalize(dir)
  local relative = normalized:match("/src/main/java/(.+)$") or normalized:match("/src/test/java/(.+)$")
  if not relative then
    return nil
  end

  local parts = {}
  for part in relative:gmatch("[^/]+") do
    if not part:match("^[%a_$][%w_$]*$") then
      return nil
    end
    parts[#parts + 1] = part
  end
  return #parts > 0 and table.concat(parts, ".") or nil
end

function M.create_java(input, dir)
  input = input and vim.trim(input) or ""
  if input == "" then
    return false
  end

  local name = identifier(input:gsub("%.java$", ""))
  if name == "" then
    return false
  end

  dir = dir or M.destination_dir()
  local package = package_for(dir)
  local lines = {}
  if package then
    vim.list_extend(lines, { "package " .. package .. ";", "" })
  end

  local class_line = #lines + 1
  vim.list_extend(lines, {
    "public class " .. name .. " {",
    "    public static void main(String[] args) {",
    "         ",
    "    }",
    "}",
  })

  return M.create(vim.fs.joinpath(dir, name .. ".java"), lines, { class_line + 2, 8 })
end

function M.create_c(input, dir)
  input = input and vim.trim(input) or ""
  if input == "" then
    return false
  end

  local name = input:gsub("%.c$", "")
  if name == "" then
    return false
  end

  dir = dir or M.destination_dir()
  return M.create(vim.fs.joinpath(dir, name .. ".c"), {
    "#include <stdio.h>",
    "",
    "int main(void)",
    "{",
    "     ",
    "    return 0;",
    "}",
  }, { 5, 4 })
end

function M.java()
  vim.ui.input({ prompt = "Nome da classe Java: " }, function(input)
    M.create_java(input)
  end)
end

function M.c()
  vim.ui.input({ prompt = "Nome do arquivo C: " }, function(input)
    M.create_c(input)
  end)
end

return M

local M = {}

M.markers = {
  ".git",
  "*.sln",
  "*.slnx",
  "*.csproj",
  "go.mod",
  "package.json",
  "pyproject.toml",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "compile_commands.json",
}

local function buffer_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr or 0)
  if name == "" then
    return nil
  end
  return vim.fs.dirname(vim.fs.normalize(name))
end

function M.get(bufnr)
  local start = buffer_path(bufnr) or vim.uv.cwd()
  local exact = {
    [".git"] = true,
    ["go.mod"] = true,
    ["package.json"] = true,
    ["pyproject.toml"] = true,
    ["pom.xml"] = true,
    ["build.gradle"] = true,
    ["build.gradle.kts"] = true,
    ["compile_commands.json"] = true,
  }
  local found = vim.fs.find(function(name)
    return exact[name] or name:match("%.slnx?$") ~= nil or name:match("%.csproj$") ~= nil
  end, { path = start, upward = true, limit = 1 })[1]
  return found and vim.fs.dirname(found) or vim.uv.cwd()
end

function M.buffer_dir(bufnr)
  return buffer_path(bufnr) or M.get(bufnr)
end

return M

local M = {}
local file_templates = require("config.file_templates")

local templates = {
  Class = function(name, namespace)
    return { "namespace " .. namespace .. ";", "", "public class " .. name, "{", "}", "" }
  end,
  Interface = function(name, namespace)
    return { "namespace " .. namespace .. ";", "", "public interface " .. name, "{", "}", "" }
  end,
  Record = function(name, namespace)
    return { "namespace " .. namespace .. ";", "", "public record " .. name .. ";", "" }
  end,
  Enum = function(name, namespace)
    return { "namespace " .. namespace .. ";", "", "public enum " .. name, "{", "}", "" }
  end,
  Controller = function(name, namespace)
    return {
      "using Microsoft.AspNetCore.Mvc;",
      "",
      "namespace " .. namespace .. ";",
      "",
      "[ApiController]",
      '[Route("api/[controller]")]',
      "public class " .. name .. " : ControllerBase",
      "{",
      "}",
      "",
    }
  end,
}

local function nearest_csproj(start)
  return vim.fs.find(function(name)
    return name:match("%.csproj$") ~= nil
  end, { path = start, upward = true, limit = 1 })[1]
end

local function project_namespace(project_file)
  local fallback = vim.fn.fnamemodify(project_file, ":t:r")
  local ok, lines = pcall(vim.fn.readfile, project_file, "", 200)
  if ok then
    for _, line in ipairs(lines) do
      local value = line:match("<RootNamespace>%s*(.-)%s*</RootNamespace>")
      if value and value ~= "" then
        return value
      end
    end
  end
  return fallback
end

local function identifier(value)
  value = value:gsub("[^%w_]", "_")
  if value:match("^%d") then
    value = "_" .. value
  end
  return value
end

local function namespace_for(dir, project)
  if not project then
    return identifier(vim.fn.fnamemodify(require("config.root").get(0), ":t"))
  end
  local project_dir = vim.fs.dirname(project)
  local namespace = project_namespace(project)
  local relative = vim.fs.relpath(project_dir, dir)
  if relative and relative ~= "." then
    local parts = {}
    for part in relative:gmatch("[^/]+") do
      parts[#parts + 1] = identifier(part)
    end
    if #parts > 0 then
      namespace = namespace .. "." .. table.concat(parts, ".")
    end
  end
  return namespace
end

function M.select()
  local kinds = { "Class", "Interface", "Record", "Enum", "Controller" }
  vim.ui.select(kinds, { prompt = "Tipo de arquivo C#:" }, function(kind)
    if not kind then
      return
    end
    vim.ui.input({ prompt = "Nome: " }, function(input)
      if not input or vim.trim(input) == "" then
        return
      end

      local name = identifier(vim.trim(input):gsub("%.cs$", ""))
      if kind == "Interface" and not name:match("^I%u") then
        name = "I" .. name
      elseif kind == "Controller" and not name:match("Controller$") then
        name = name .. "Controller"
      end

      local dir = file_templates.destination_dir()
      local path = vim.fs.joinpath(dir, name .. ".cs")
      local project = nearest_csproj(dir)
      local namespace = namespace_for(dir, project)
      file_templates.create(path, templates[kind](name, namespace))
    end)
  end)
end

return M

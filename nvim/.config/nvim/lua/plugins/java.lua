local function java_bundles()
  local mason = vim.fn.stdpath("data") .. "/mason/packages"
  local bundles = {}

  local debug_jar = vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
  if debug_jar ~= "" then
    bundles[#bundles + 1] = debug_jar
  end

  local test_jars = vim.split(vim.fn.glob(mason .. "/java-test/extension/server/*.jar", true), "\n", { trimempty = true })
  for _, jar in ipairs(test_jars) do
    local filename = vim.fs.basename(jar)
    if filename ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar" and filename ~= "jacocoagent.jar" then
      bundles[#bundles + 1] = jar
    end
  end
  return bundles
end

local function java_executable()
  local candidates = { vim.fn.exepath("java") }
  vim.list_extend(candidates, vim.fn.glob("/usr/lib/jvm/*/bin/java", false, true))
  for _, candidate in ipairs(candidates) do
    if candidate ~= "" and vim.fn.executable(candidate) == 1 then
      local result = vim.system({ candidate, "-version" }, { text = true }):wait()
      local major = tonumber((result.stderr or ""):match('version "(%d+)'))
      if result.code == 0 and major and major >= 21 then
        return candidate
      end
    end
  end
end

local function start_jdtls(bufnr)
  local root = vim.fs.root(bufnr, { ".git", "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts" })
    or vim.fs.root(bufnr, { "pom.xml", "build.gradle", "build.gradle.kts" })
  if not root then
    return
  end

  local java = java_executable()
  if not java then
    vim.notify_once("JDTLS exige Java 21+ (Arch: sudo pacman -S jdk-openjdk)", vim.log.levels.WARN)
    return
  end

  local workspace = vim.fn.stdpath("state") .. "/jdtls/" .. vim.fn.sha256(root):sub(1, 16)
  local config = {
    name = "jdtls",
    cmd = { "jdtls", "--java-executable", java, "-data", workspace },
    root_dir = root,
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    settings = {
      java = {
        eclipse = { downloadSources = true },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        signatureHelp = { enabled = true },
        format = { enabled = true },
      },
    },
    init_options = { bundles = java_bundles() },
    on_attach = function()
      local jdtls = require("jdtls")
      pcall(jdtls.setup_dap, { hotcodereplace = "auto" })
      pcall(require("jdtls.dap").setup_dap_main_class_configs)
    end,
  }
  require("jdtls").start_or_attach(config)
end

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mfussenegger/nvim-dap", "saghen/blink.cmp" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function(args)
          start_jdtls(args.buf)
        end,
      })
      if vim.bo.filetype == "java" then
        start_jdtls(0)
      end
    end,
  },
}

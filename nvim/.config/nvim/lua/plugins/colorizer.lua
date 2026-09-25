return {
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = { "*" },
      options = {
        parsers = { css = true },
        display = { mode = "background" },
      },
    },
  },
}

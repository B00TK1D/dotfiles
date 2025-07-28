-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  filetype = {
    lua = require("formatter.filetypes.lua").stylua,
    python = require("formatter.filetypes.python").black,
    javascript = require("formatter.filetypes.javascript").prettier,
    typescript = require("formatter.filetypes.javascript").prettier,
    -- json = require("formatter.filetypes.json").prettier,
    html = require("formatter.filetypes.html").prettier,
    css = require("formatter.filetypes.css").prettier,
    markdown = require("formatter.filetypes.markdown").prettier,
    yaml = require("formatter.filetypes.yaml").prettier,
    sh = require("formatter.filetypes.sh").shfmt,
    go = {
      require("formatter.filetypes.go").gofmt,
    },
    rust = require("formatter.filetypes.rust").rustfmt,

    --["*"] = require("formatter.filetypes.any").remove_trailing_whitespace,
  },
}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
  group = "__formatter__",
  command = ":FormatWrite",
})

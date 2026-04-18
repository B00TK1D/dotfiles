--- This module loads the darker onedark variant used in the reference config.

vim.opt.background = "dark"

local M = {}

--- Load the onedark_dark colorscheme.
M.load_colorscheme = function()
  vim.cmd([[colorscheme onedark_dark]])
  return "onedark_dark"
end

M.load_colorscheme()

-- enable the experiment UI
require("vim._core.ui2").enable {
  enable = true,
  msg = { -- Options related to the message module.
    targets = {
      [""] = "cmd",
      empty = "msg",
    },
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.2, -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = { -- Options related to dialog window.
      height = 0.2, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.2, -- Maximum height.
      timeout = 1000, -- Time a message is visible in the message window.
    },
    pager = { -- Options related to message window.
      height = 0.3, -- Maximum height.
    },
  },
}

return M

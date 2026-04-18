local glance = require("glance")

glance.setup {
  height = 25,
  border = {
    enable = true,
  },
}

vim.keymap.set("n", "<space>ld", "<cmd>Glance definitions<cr>")
vim.keymap.set("n", "<space>lr", "<cmd>Glance references<cr>")
vim.keymap.set("n", "<space>li", "<cmd>Glance implementations<cr>")

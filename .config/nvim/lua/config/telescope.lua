local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { cwd = root })
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fs", builtin.live_grep, { cwd = root })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, {})
vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, {})
vim.keymap.set("n", "<leader>fo", builtin.lsp_outgoing_calls, {})

local telescope = require("telescope")

telescope.setup {
  pickers = {
    find_files = {
      hidden = false,
      file_ignore_patterns = { "^./.git/", "^node_modules/" },
    },
  },
}

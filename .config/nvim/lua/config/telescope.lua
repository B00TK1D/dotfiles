local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { cwd = root })
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fs", builtin.live_grep, { cwd = root })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, {})
vim.keymap.set("n", "<leader>fi", builtin.lsp_incoming_calls, {})
vim.keymap.set("n", "<leader>fo", builtin.lsp_outgoing_calls, {})

local telescope = require("telescope")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local close_if_empty = function(prompt_bufnr)
  local current_line = action_state.get_current_line()
  if current_line == "" then
    actions.close(prompt_bufnr)
  end
end

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<bs>"] = close_if_empty,
        ["<c-h>"] = close_if_empty,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = false,
      file_ignore_patterns = { "^./.git/", "^node_modules/" },
    },
  },
}

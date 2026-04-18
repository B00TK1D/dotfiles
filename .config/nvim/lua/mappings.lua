local keymap = vim.keymap
local uv = vim.uv

-- Save key strokes (now we do not need to press shift to enter command mode).
keymap.set({ "n", "x" }, ";", ":")

-- Jump up and down paragraphs with J and K
keymap.set({ "n", "x" }, "K", function()
  vim.cmd("keepjumps normal! {")
end, { desc = "jump to previous paragraph" })
keymap.set({ "n", "x" }, "J", function()
  vim.cmd("keepjumps normal! }")
end, { desc = "jump to next paragraph" })

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
keymap.set("n", "<leader>p", "m`o<ESC>p``", { desc = "paste below current line" })
keymap.set("n", "<leader>P", "m`O<ESC>p``", { desc = "paste above current line" })

-- Replace file with <leader>a and <leader>v
vim.keymap.set("n", "<leader>v", function()
  local pos = vim.api.nvim_win_get_cursor(0)  -- Save cursor position
  local clipboard = vim.fn.getreg("+")        -- Get clipboard content

  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(clipboard, "\n"))  -- Replace buffer
  vim.api.nvim_win_set_cursor(0, pos)         -- Restore cursor
end, { desc = "Replace buffer with clipboard" })

vim.keymap.set('n', '<leader>a', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! ggVG"+y')
  vim.api.nvim_win_set_cursor(0, pos)
end, { noremap = true, silent = true })

-- Shortcut for faster save and quit
keymap.set("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "save buffer" })

-- Save all modified files and quit Neovim, or close diagnostics buffer if that's what we're on
keymap.set("n", "<leader>q", function()
  if vim.bo.buftype == "quickfix" then
    vim.cmd("cclose")
  else
    vim.g.nvim_quitting = true
    vim.cmd("xall")
  end
end, { silent = true, nowait = true, desc = "quit nvim or close diagnostics" })

-- Quit all opened buffers
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { silent = true, desc = "quit nvim" })

-- Close location list or quickfix list if they are present, see https://superuser.com/q/355325/736190
keymap.set("n", [[\x]], "<cmd>windo lclose <bar> cclose <cr>", {
  silent = true,
  desc = "close qf and location list",
})

-- Delete a buffer, without closing the window, see https://stackoverflow.com/q/4465095/6064933
keymap.set("n", [[\db]], "<cmd>bprevious <bar> bdelete #<cr>", {
  silent = true,
  desc = "Delete current buffer",
})

keymap.set("n", [[\dB]], function()
  local buf_ids = vim.api.nvim_list_bufs()
  local cur_buf = vim.api.nvim_win_get_buf(0)

  for _, buf_id in pairs(buf_ids) do
    -- do not Delete unlisted buffers, which may lead to unexpected errors
    if vim.api.nvim_get_option_value("buflisted", { buf = buf_id }) and buf_id ~= cur_buf then
      vim.api.nvim_buf_delete(buf_id, { force = true })
    end
  end
end, {
  desc = "Delete other buffers",
})

keymap.set("n", [[\dt]], "<cmd>tabclose<CR>", {
  silent = true,
  desc = "Delete current tab",
})

keymap.set("n", [[\dT]], "<cmd>tabonly<CR>", {
  silent = true,
  desc = "Delete other tabs",
})

-- Move the cursor based on physical lines, not the actual lines.
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap.set("n", "^", "g^")
keymap.set("n", "0", "g0")

-- Do not include white space characters when using $ in visual mode,
-- see https://vi.stackexchange.com/q/12607/15292
keymap.set("x", "$", "g_")

-- Go to start or end of line easier
keymap.set({ "n", "x" }, "H", "^")
keymap.set({ "n", "x" }, "L", "g_")

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
keymap.set("x", "<", "<gv")
keymap.set("x", ">", ">gv")

-- Reload nvim config
keymap.set("n", "<leader>r", function()
  local config_dir = vim.fn.stdpath("config")
  local lua_dir = config_dir .. "/lua"

  -- Get list of all lua files in lua/ directory
  local function get_lua_files(dir)
    local files = {}
    local items = vim.fn.glob(dir .. "/*.lua", true, true)
    for _, item in ipairs(items) do
      table.insert(files, item)
    end
    local dirs = vim.fn.glob(dir .. "/*", true, true)
    for _, dir_item in ipairs(dirs) do
      if vim.fn.isdirectory(dir_item) then
        local sub_files = get_lua_files(dir_item)
        for _, f in ipairs(sub_files) do
          table.insert(files, f)
        end
      end
    end
    return files
  end

  local files = get_lua_files(lua_dir)
  for _, filepath in ipairs(files) do
    local rel_path = filepath:sub(#lua_dir + 2)
    local module_name = rel_path:gsub("%.lua$", ""):gsub("/", ".")
    if package.loaded[module_name] then
      package.loaded[module_name] = nil
    end
  end

  -- lazy.nvim does not support re-sourcing, so unset its guard flag temporarily
  if package.loaded["lazy"] then
    vim.g.lazy_did_setup = nil
  end

  dofile(config_dir .. "/init.lua")

  -- Re-trigger filetype to re-apply ftplugin settings (tabstop, etc.)
  vim.cmd("do FileType")

  vim.notify("Configuration reloaded!", vim.log.levels.INFO)
end, { desc = "reload nvim config" })

-- Restart nvim
keymap.set("n", "<leader>ns", function()
  vim.print("Use ZR to restart nvim instead!")
end)

keymap.set("n", "ZR", function()
  local current_buf_path = vim.fn.expand("%")
  local restart_cmd = string.format("restart edit %s", current_buf_path)
  vim.cmd(restart_cmd)
end, {
  silent = true,
  desc = "Restart nvim",
})

-- Always use very magic mode for searching
-- keymap.set("n", "/", [[/\v]])

-- Search in selected region
-- xnoremap / :<C-U>call feedkeys('/\%>'.(line("'<")-1).'l\%<'.(line("'>")+1)."l")<CR>

-- Use Esc to quit builtin terminal
keymap.set("t", "<Esc>", [[<c-\><c-n>]])

-- Toggle spell checking
keymap.set("n", "<F11>", "<cmd>set spell!<cr>", { desc = "toggle spell" })
keymap.set("i", "<F11>", "<c-o><cmd>set spell!<cr>", { desc = "toggle spell" })

-- Change text without putting it into the vim register,
-- see https://stackoverflow.com/q/54255/6064933
keymap.set("n", "c", '"_c')
keymap.set("n", "C", '"_C')
keymap.set("n", "cc", '"_cc')
keymap.set("x", "c", '"_c')

-- Remove trailing whitespace characters
keymap.set(
  "n",
  "<leader><space>",
  "<cmd>StripTrailingWhitespace<cr>",
  { desc = "remove trailing space" }
)

-- Move current line up and down
keymap.set(
  "n",
  "<A-k>",
  '<cmd>call utils#SwitchLine(line("."), "up")<cr>',
  { desc = "move line up" }
)
keymap.set(
  "n",
  "<A-j>",
  '<cmd>call utils#SwitchLine(line("."), "down")<cr>',
  { desc = "move line down" }
)

-- Move current visual-line selection up and down
keymap.set("x", "<A-k>", '<cmd>call utils#MoveSelection("up")<cr>', { desc = "move selection up" })

keymap.set(
  "x",
  "<A-j>",
  '<cmd>call utils#MoveSelection("down")<cr>',
  { desc = "move selection down" }
)

-- Replace visual selection with text in register, but not contaminate the register,
-- see also https://stackoverflow.com/q/10723700/6064933.
keymap.set("x", "p", '"_c<Esc>p')

-- Go to a certain buffer
keymap.set("n", "<leader>b", '<cmd>call buf_utils#GoToBuffer(v:count, "forward")<cr>', {
  desc = "go to buffer (forward)",
})
keymap.set("n", "<leader>B", '<cmd>call buf_utils#GoToBuffer(v:count, "backward")<cr>', {
  desc = "go to buffer (backward)",
})

keymap.set("n", "<leader>g", function()
  if vim.fn.executable("lazygit") == 0 then
    vim.notify("lazygit is not installed", vim.log.levels.ERROR)
    return
  end

  local width = math.floor(vim.o.columns * 0.95)
  local height = math.floor(vim.o.lines * 0.9)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  vim.bo[buf].bufhidden = "wipe"

  vim.fn.termopen("lazygit", {
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end)
    end,
  })
  vim.cmd.startinsert()
end, {
  desc = "open lazygit",
})

-- Switch windows
keymap.set("n", "<left>", "<c-w>h")
keymap.set("n", "<Right>", "<C-W>l")
keymap.set("n", "<Up>", "<C-W>k")
keymap.set("n", "<Down>", "<C-W>j")

-- Text objects for URL
keymap.set({ "x", "o" }, "iu", "<cmd>call text_obj#URL()<cr>", { desc = "URL text object" })

-- Text objects for entire buffer
keymap.set({ "x", "o" }, "iB", ":<C-U>call text_obj#Buffer()<cr>", { desc = "buffer text object" })

-- Do not move my cursor when joining lines.
keymap.set("n", "<leader>j", function()
  vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

keymap.set("n", "gJ", function()
  -- we must use `normal!`, otherwise it will trigger recursive mapping
  vim.cmd([[
      normal! mzgJ`z
      delmarks z
    ]])
end, {
  desc = "join lines without moving cursor",
})

-- Break inserted text into smaller undo units when we insert some punctuation chars.
local undo_ch = { ",", ".", "!", "?", ";", ":" }
for _, ch in ipairs(undo_ch) do
  keymap.set("i", ch, ch .. "<c-g>u")
end

-- insert semicolon in the end
keymap.set("i", "<A-;>", "<Esc>miA;<Esc>`ii")

-- Go to the beginning and end of current line in insert mode quickly
keymap.set("i", "<C-A>", "<HOME>")
keymap.set("i", "<C-E>", "<END>")

-- Go to beginning of command in command-line mode
keymap.set("c", "<C-A>", "<HOME>")

-- Delete the character to the right of the cursor
keymap.set("i", "<C-D>", "<DEL>")

keymap.set("n", "q", function()
  vim.print("q is remapped to Q in Normal mode!")
end)
keymap.set("n", "Q", "q", {
  desc = "Record macro",
})

keymap.set("n", "<Esc>", function()
  vim.cmd("fclose!")
end, {
  desc = "close floating win",
})

keymap.set("n", "<leader>kf", function()
  vim.lsp.buf.format()
end, { desc = "format buffer" })

-- Comment/uncomment current line
vim.keymap.set("n", "<leader>c", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gcc", true, true, true), "m", true)
end, { desc = "comment line" })
vim.keymap.set("x", "<leader>c", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gc", true, true, true), "x", true)
end, { desc = "comment selection" })

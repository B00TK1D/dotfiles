local M = {}

local state_file = vim.fs.joinpath(vim.fn.stdpath("state"), "nvim-tree-state.json")
M.restoring = false
M.focused_path = nil

local function normalize(path)
  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function ensure_parent_dir()
  local dir = vim.fn.fnamemodify(state_file, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

local function read_state()
  local fd = vim.uv.fs_open(state_file, "r", 420)
  if not fd then
    return {}
  end

  local stat = vim.uv.fs_fstat(fd)
  local content = stat and vim.uv.fs_read(fd, stat.size, 0) or nil
  vim.uv.fs_close(fd)

  if not content or content == "" then
    return {}
  end

  local ok, decoded = pcall(vim.json.decode, content)
  if not ok or type(decoded) ~= "table" then
    return {}
  end

  return decoded
end

local function write_state(state)
  ensure_parent_dir()

  local fd = assert(vim.uv.fs_open(state_file, "w", 420))
  vim.uv.fs_write(fd, vim.json.encode(state), 0)
  vim.uv.fs_close(fd)
end

local function collect_open_dirs(node, open_dirs)
  if node.nodes == nil then
    return
  end

  if not node.open then
    return
  end

  table.insert(open_dirs, normalize(node.absolute_path))

  for _, child in ipairs(node.nodes) do
    collect_open_dirs(child, open_dirs)
  end
end

local function open_node(node)
  if not node or node.nodes == nil then
    return
  end

  local target = node.last_group_node and node:last_group_node() or node
  target.open = true

  if #target.nodes == 0 then
    target.explorer:expand_dir_node(target)
  end
end

local function expand_path(explorer, root, path)
  local normalized_path = normalize(path)
  local normalized_root = normalize(root)

  if normalized_path == normalized_root then
    return explorer
  end

  local relative = vim.fn.fnamemodify(normalized_path, ":.")
  if normalized_path:sub(1, #normalized_root) ~= normalized_root then
    return nil
  end

  relative = normalized_path:sub(#normalized_root + 1)
  relative = relative:gsub("^/", "")
  if relative == "" then
    return explorer
  end

  local current_path = normalized_root
  local node = explorer

  for part in relative:gmatch("[^/]+") do
    current_path = vim.fs.joinpath(current_path, part)
    local next_node = explorer:get_node_from_path(current_path)

    if not next_node then
      if node and node.nodes then
        open_node(node)
        next_node = explorer:get_node_from_path(current_path)
      end

      if not next_node then
        return nil
      end
    end

    node = next_node
  end

  return node
end

function M.save()
  local ok_core, core = pcall(require, "nvim-tree.core")
  if not ok_core then
    return
  end

  local explorer = core.get_explorer()
  if M.restoring or not explorer then
    return
  end

  local root = normalize(explorer.absolute_path)
  local open_dirs = {}

  for _, node in ipairs(explorer.nodes or {}) do
    collect_open_dirs(node, open_dirs)
  end

  local state = read_state()
  state[root] = {
    open_dirs = open_dirs,
    focused_path = M.focused_path,
  }

  write_state(state)
end

function M.restore(root_path)
  local ok_core, core = pcall(require, "nvim-tree.core")
  if not ok_core then
    M.restoring = false
    return
  end

  local root = normalize(root_path)
  local state = read_state()[root]
  local explorer = core.get_explorer()
  if not state or not explorer then
    M.restoring = false
    return
  end

  M.restoring = true

  table.sort(state.open_dirs or {}, function(a, b)
    return #a < #b
  end)

  for _, path in ipairs(state.open_dirs or {}) do
    if path ~= root then
      local node = expand_path(explorer, root, path)
      if node and node.nodes and not node.open then
        open_node(node)
      end
    end
  end

  local focused_path = state.focused_path
  if focused_path then
    local focused_node = expand_path(explorer, root, focused_path)
    explorer:focus_node_or_parent(focused_node)
  end

  explorer.renderer:draw()
  M.restoring = false
  M.save()
end

function M.setup()
  local api = require("nvim-tree.api")
  local events = api.events.Event

  api.events.subscribe(events.TreeRendered, function()
    local focused = api.tree.get_node_under_cursor()
    if focused and focused.absolute_path then
      M.focused_path = normalize(focused.absolute_path)
    end
    vim.schedule(M.save)
  end)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("persist_nvim_tree_state", { clear = true }),
    callback = M.save,
  })
end

return M

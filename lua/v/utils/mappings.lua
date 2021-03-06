local t = v.replace_termcodes
local fn = vim.fn

-- TODO: setup whichkey registering on the fly
-- https://github.com/folke/which-key.nvim#-setup
-- https://github.com/akinsho/dotfiles/blob/c81dadf0c570ce39543a9b43a75f41256ecd03fc/.config/nvim/lua/as/plugins/lspconfig.lua#L61-L119
-- https://github.com/folke/which-key.nvim/issues/153

local M = {}

---Wrapper for `vim.keymap.set`
---@param mode string|string[] mode or list of modes (`:h map-modes`)
---@param lhs string keybinding
---@param rhs string|function action
---@param opts table<string, boolean|string> usual map options + `buffer` (`:h vim.keymap.set`)
function M.map(mode, lhs, rhs, opts)
  if not lhs then
    vim.api.nvim_notify('No LHS.', vim.log.levels.ERROR, {
      title = 'Mapping',
    })
    return
  end

  local options = vim.tbl_extend('force', {
    silent = true,
    nowait = true, -- TODO: does this break anything?
    replace_keycodes = false,
  }, opts or {})

  if options.buffer and type(options.buffer) ~= 'number' then
    options.buffer = 0
  end

  vim.keymap.set(mode, lhs, rhs, options)
end

---Wrapper for `vim.keymap.del`
---@param mode string|string[] mode or list of modes (`:h map-modes`)
---@param lhs string keybinding
---@param buffer? number buffer id
function M.unmap(mode, lhs, buffer)
  if not lhs then
    vim.api.nvim_notify('No LHS.', vim.log.levels.ERROR, { title = 'Unmapping' })
    return
  end

  local ok, _ = pcall(vim.keymap.del, mode, lhs, { buffer = buffer })

  if not ok then
    M.map(mode, lhs, t('<nop>'), { buffer = buffer })
  end
end

---@class UnkeybindingTable
---@field mode string|string[] mode or list of modes (`:h map-modes`)
---@field lhs string keybinding
---@param buffer? number buffer id

---Unsets a list of keybindings.
---@param args UnkeybindingTable[] parameters to be passed to v.utils.mappings.unmap
---@see v.utils.mappings.unmap
function M.unset_keybindings(args)
  for _, map_table in ipairs(args) do
    M.unmap(unpack(map_table))
  end
end

return M

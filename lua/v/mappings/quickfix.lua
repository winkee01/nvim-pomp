---------------------------------------------------------------------------------
-- Toggle list
---------------------------------------------------------------------------------
--- Toggle the quickfix list or location list
---@param list_type '"quickfix"' | '"location"'
---@return nil
function v.toggle_list(list_type)
  local is_location_target = list_type == 'location'
  local prefix = is_location_target and 'l' or 'c'
  local L = vim.log.levels
  local is_open = v.is_vim_list_open()
  if is_open then
    return vim.fn.execute(prefix .. 'close')
  end
  local list = is_location_target and vim.fn.getloclist(0) or vim.fn.getqflist()
  if vim.tbl_isempty(list) then
    local msg_prefix = (is_location_target and 'Location' or 'QuickFix')
    return vim.notify(msg_prefix .. ' List is Empty.', L.WARN)
  end

  local winnr = vim.fn.winnr()
  vim.fn.execute(prefix .. 'open')
  if vim.fn.winnr() ~= winnr then
    vim.cmd('wincmd p')
  end
end

v.set_keybindings({
  {'n', '<leader>lq', function() v.toggle_list('quickfix') end },
  {'n', '<leader>ll', function() v.toggle_list('location') end },
})
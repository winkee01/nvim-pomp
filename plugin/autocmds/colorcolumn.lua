local column_exclude = { 'gitcommit' }
local column_clear = {
  'startify',
  'vimwiki',
  'vim-plug',
  'help',
  'fugitive',
  'mail',
  'org',
  'orgagenda',
  'NeogitStatus',
  'norg',
}

--- Set or unset the color column depending on the filetype of the buffer and its eligibility
---@param leaving boolean indicates if the function was called on window leave
local function check_color_column(leaving)
  if vim.tbl_contains(column_exclude, vim.bo.filetype) then
    return
  end

  local not_eligible = not vim.bo.modifiable
    or vim.wo.previewwindow
    or vim.bo.buftype ~= ''
    or not vim.bo.buflisted

  local small_window = vim.api.nvim_win_get_width(0) <= vim.bo.textwidth + 1
  local is_last_win = #vim.api.nvim_list_wins() == 1

  if
    vim.tbl_contains(column_clear, vim.bo.filetype)
    or not_eligible
    or (leaving and not is_last_win)
    or small_window
  then
    vim.wo.colorcolumn = ''
    return
  end
  if vim.wo.colorcolumn == '' then
    vim.wo.colorcolumn = '+1'
  end
end

v.augroup('CustomColorColumn', {
  {
    -- Update the cursor column to match current window size
    event = { 'WinEnter', 'BufEnter', 'VimResized', 'FileType' },
    pattern = '*',
    command = function()
      check_color_column()
    end,
  },
  {
    event = { 'WinLeave' },
    pattern = { '*' },
    command = function()
      check_color_column(true)
    end,
  },
})
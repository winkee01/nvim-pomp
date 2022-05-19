-- only show cursorline when buffer type is not 'terminal' 
-- and not in previewwindow
-- and window is set winhighlight
-- and filetype is recognized

local function should_show_cursorline()
  return vim.bo.buftype ~= 'terminal'
    and not vim.wo.previewwindow
    and vim.wo.winhighlight == ''
    and vim.bo.filetype ~= ''
end

v.augroup('Cursorline', {
  {
    event = { 'BufEnter' },
    pattern = { '*' },
    command = function()
      if should_show_cursorline() then
        vim.wo.cursorline = true
      end
    end,
  },
  {
    event = { 'BufLeave' },
    pattern = { '*' },
    command = function()
      vim.wo.cursorline = false
    end,
  },
})

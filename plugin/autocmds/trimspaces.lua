function trim_trailing_whitespaces()
  local o = vim.o
  if not o.binary and o.filetype ~= 'diff' then
    local current_view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(current_view)
  end
end

v.augroup('TrimTrailingWhitespaces', {
  {
    event = 'BufWritePre',
    command = function()
      trim_trailing_whitespaces() 
    end,
  },
})
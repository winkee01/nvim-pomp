v.augroup('ExternalCommands', {
  {
    -- Open images in an image viewer (probably Preview)
    event = { 'BufEnter' },
    pattern = { '*.png', '*.jpg', '*.gif' },
    command = function()
      vim.cmd(fmt('silent! "%s | :bw"', vim.g.open_command .. ' ' .. fn.expand('%')))
    end,
  },
})
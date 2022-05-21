v.command('ToggleBackground', function()
  vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
end)
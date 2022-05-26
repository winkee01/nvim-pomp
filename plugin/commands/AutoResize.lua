-----------------------------------------------------------------------------//
-- Autoresize
-----------------------------------------------------------------------------//
-- Auto resize Vim splits to active split to 70% -
-- https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window
local fmt = string.format

local auto_resize = function()
  local auto_resize_on = false
  return function(args)
    if not auto_resize_on then
      local factor = args and tonumber(args) or 70
      local fraction = factor / 10
      -- NOTE: mutating &winheight/&winwidth are key to how
      -- this functionality works, the API fn equivalents do
      -- not work the same way
      -- TODO: if vim.bo.buftype == 'nvim-tree'
      vim.cmd(fmt('let &winheight=&lines * %d / 10 ', fraction))
      vim.cmd(fmt('let &winwidth=&columns * %d / 10 ', fraction))

      auto_resize_on = true
      -- vim.notify('Auto resize ON')
    else
      vim.cmd('let &winheight=30')
      vim.cmd('let &winwidth=30')
      vim.cmd('wincmd =')
      auto_resize_on = false
      vim.notify('Auto resize OFF')
    end
  end
end

v.create_command('AutoResize', auto_resize(), { nargs = '?' })

-- if not AutoResize then
--   vim.cmd('AutoResize')
-- end
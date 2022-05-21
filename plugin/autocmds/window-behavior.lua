v.augroup('WindowBehaviours', {
  {
    -- map q to close command window on quit
    event = { 'CmdwinEnter' },
    pattern = { '*' },
    command = 'nnoremap <silent><buffer><nowait> q <C-W>c',
  },
  -- Automatically jump into the quickfix window on open
  {
    event = { 'QuickFixCmdPost' },
    pattern = { '[^l]*' },
    nested = true,
    command = 'cwindow',
  },
  {
    event = { 'QuickFixCmdPost' },
    pattern = { 'l*' },
    nested = true,
    command = 'lwindow',
  },
})
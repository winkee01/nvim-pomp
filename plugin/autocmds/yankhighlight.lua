v.augroup('TextYankHighlight', {
  {
    -- don't execute silently in case of errors
    event = { 'TextYankPost' },
    pattern = '*',
    command = function()
      vim.highlight.on_yank({
        timeout = 200,
        on_visual = false,
        higroup = 'Visual',
      })
    end,
  },
})
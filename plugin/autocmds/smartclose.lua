local smart_close_filetypes = {
  'help',
  'git-status',
  'git-log',
  'gitcommit',
  'dbui',
  'fugitive',
  'fugitiveblame',
  'LuaTree',
  'log',
  'tsplayground',
  'qf',
}

local function smart_close()
  if vim.fn.winnr '$' ~= 1 then
    vim.api.nvim_win_close(0, true)
  end
end

v.augroup('SmartClose', {
  {
    -- Auto open grep quickfix window
    event = { 'QuickFixCmdPost' },
    targets = { '*grep*' },
    command = 'cwindow',
  },
  {
    -- Close certain filetypes by pressing q.
    event = { 'FileType' },
    targets = { '*' },
    command = function()
      local is_readonly = (vim.bo.readonly or not vim.bo.modifiable) and vim.fn.hasmapto('q', 'n') == 0

      local is_eligible = vim.bo.buftype ~= ''
        or is_readonly
        or vim.wo.previewwindow
        or vim.tbl_contains(smart_close_filetypes, vim.bo.filetype)

      if is_eligible then
        v.nnoremap('q', smart_close, { buffer = 0, nowait = true })
      end
    end,
  },
  {
    -- Close quick fix window if the file containing it was closed
    event = { 'BufEnter' },
    targets = { '*' },
    command = function()
      if vim.fn.winnr '$' == 1 and vim.bo.buftype == 'quickfix' then
        api.nvim_buf_delete(0, { force = true })
      end
    end,
  },
  {
    -- automatically close corresponding loclist when quitting a window
    event = { 'QuitPre' },
    targets = { '*' },
    modifiers = { 'nested' },
    command = function()
      if vim.bo.filetype ~= 'qf' then
        vim.cmd 'silent! lclose'
      end
    end,
  },
})
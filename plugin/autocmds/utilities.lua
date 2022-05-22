local save_excluded = { 'lua.luapad', 'gitcommit', 'NeogitCommitMessage' }
local function can_save()
  return v.is_empty(vim.bo.buftype)
    and not v.is_empty(vim.bo.filetype)
    and vim.bo.modifiable
    and not vim.tbl_contains(save_excluded, vim.bo.filetype)
end

v.augroup('Utilities', {
  {
    -- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
    event = { 'BufReadCmd' },
    pattern = { 'file:///*' },
    nested = true,
    command = function(args)
      vim.cmd(fmt('bd!|edit %s', vim.uri_to_fname(args.file)))
    end,
  },
  {
    -- When editing a file, always jump to the last known cursor position.
    -- Don't do it for commit messages, when the position is invalid.
    event = { 'BufReadPost' },
    command = function()
      if vim.bo.ft ~= 'gitcommit' and vim.fn.win_gettype() ~= 'popup' then
        if vim.fn.line([['"]]) > 0 and vim.fn.line([['"]]) <= vim.fn.line('$') then
          -- Check if the last line of the buffer is the same as the window
          if vim.fn.line('w$') == vim.fn.line('$') then
            -- Set line to last line edited
            vim.cmd([[normal! g`"]])
            -- Try to center
          elseif vim.fn.line('$') - vim.fn.line([['"]]) > ((vim.fn.line('w$') - vim.fn.line('w0')) / 2) - 1 then
            vim.cmd([[normal! g`"zz]])
          else
            vim.cmd([[normal! G'"<c-e>]])
          end
        end
      end
    end,
  },
  {
    event = { 'FileType' },
    pattern = { 'gitcommit', 'gitrebase' },
    command = 'set bufhidden=delete',
  },
  { -- TODO: should this be done in ftplugin files
    event = { 'FileType' },
    pattern = { 'markdown' },
    command = 'setlocal spell',
  },
  {
    event = { 'BufWritePre', 'FileWritePre' },
    pattern = { '*' },
    command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
  },
  {
    event = { 'BufLeave' },
    pattern = { '*' },
    command = function()
      if can_save() then
        vim.cmd('silent! update')
      end
    end,
  },
  {
    event = { 'BufWritePost' },
    pattern = { '*' },
    nested = true,
    command = function()
      if v.is_empty(vim.bo.filetype) or vim.fn.exists('b:ftdetect') == 1 then
        vim.cmd([[
            unlet! b:ftdetect
            filetype detect
            echom 'Filetype set to ' . &ft
          ]])
      end
    end,
  },
  {
    event = { 'Syntax' },
    pattern = { '*' },
    command = "if 5000 < line('$') | syntax sync minlines=200 | endif",
  },
})
function v.mappings.grep_operator(type)
  local saved_unnamed_register = vim.fn.getreg('@@')
  if type:match('v') then
    vim.cmd([[normal! `<v`>y]])
  elseif type:match('char') then
    vim.cmd([[normal! `[v`]y']])
  else
    return
  end
  -- Use Winnr to check if the cursor has moved it if has restore it
  local winnr = vim.fn.winnr()
  vim.cmd([[silent execute 'grep! ' . shellescape(@@) . ' .']])
  vim.fn.setreg('@@', saved_unnamed_register)
  if vim.fn.winnr() ~= winnr then
    vim.cmd([[wincmd p]])
  end
end

require('v.utils.mappings').set_keybindings({
  -- http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/
  { 'n', '<leader>g', [[:silent! set operatorfunc=v:lua.v.mappings.grep_operator<cr>g@]] },
  { 'x', '<leader>g', [[:call v:lua.v.mappings.grep_operator(visualmode())<cr>]] },
})
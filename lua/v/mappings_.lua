-----------------------------------------------------------------------------//
-- Terminal {{{
------------------------------------------------------------------------------//
v.augroup('AddTerminalMappings', {
  {
    event = { 'TermOpen' },
    pattern = { 'term://*' },
    command = function()
      if vim.bo.filetype == '' or vim.bo.filetype == 'toggleterm' then
        require('v.utils.mappings').set_keybindings ({
          { 't', '<esc>', [[<C-\><C-n>]] },
          { 't', 'jk', [[<C-\><C-n>]] },
          { 't', '<C-h>', [[<C-\><C-n><C-W>h]] },
          { 't', '<C-j>', [[<C-\><C-n><C-W>j]] },
          { 't', '<C-k>', [[<C-\><C-n><C-W>k]] },
          { 't', '<C-l>', [[<C-\><C-n><C-W>l]] },
          { 't', ']t', [[<C-\><C-n>:tablast<CR>]] },
          { 't', '[t', [[<C-\><C-n>:tabnext<CR>]] },
          { 't', '<S-Tab>', [[<C-\><C-n>:bprev<CR>]] },
          { 't', '<leader><Tab>', [[<C-\><C-n>:close \| :bnext<cr>]] },
        })
      end
    end,
  },
})

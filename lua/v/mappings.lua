local fn = vim.fn
local api = vim.api
local command = v.command
local fmt = string.format

local nmap = v.nmap
local imap = v.imap
local nnoremap = v.nnoremap
local xnoremap = v.xnoremap
local vnoremap = v.vnoremap
local inoremap = v.inoremap
local onoremap = v.onoremap
local cnoremap = v.cnoremap
local tnoremap = v.tnoremap

-----------------------------------------------------------------------------//
-- Terminal {{{
------------------------------------------------------------------------------//
v.augroup('AddTerminalMappings', {
  {
    event = { 'TermOpen' },
    pattern = { 'term://*' },
    command = function()
      if vim.bo.filetype == '' or vim.bo.filetype == 'toggleterm' then
        local opts = { silent = false, buffer = 0 }
        tnoremap('<esc>', [[<C-\><C-n>]], opts)
        tnoremap('jk', [[<C-\><C-n>]], opts)
        tnoremap('<C-h>', [[<C-\><C-n><C-W>h]], opts)
        tnoremap('<C-j>', [[<C-\><C-n><C-W>j]], opts)
        tnoremap('<C-k>', [[<C-\><C-n><C-W>k]], opts)
        tnoremap('<C-l>', [[<C-\><C-n><C-W>l]], opts)
        tnoremap(']t', [[<C-\><C-n>:tablast<CR>]])
        tnoremap('[t', [[<C-\><C-n>:tabnext<CR>]])
        tnoremap('<S-Tab>', [[<C-\><C-n>:bprev<CR>]])
        tnoremap('<leader><Tab>', [[<C-\><C-n>:close \| :bnext<cr>]])
      end
    end,
  },
})

xnoremap('al', '$o0')
onoremap('al', '<cmd>normal val<CR>')

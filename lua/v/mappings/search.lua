-- ###### Quick Search & Replace ######

require('v.utils.mappings').set_keybindings({
    -- ^^^^^^ (1) Search words under the cursor ^^^^^^
    -- ^^^^^^ (2) Replace whole word one by one, press . to repeat ^^^^^^
    -- ^^^^^^ (3) Replace the whole word under the cursor ^^^^^^
    -- { 'n', '<Leader>s', [[ :%s/\<<C-r><C-w>\>//g<Left><Left> ]] },
    -- { 'n', '<Leader>sc', [[ :%s/\<<C-r><C-w>\>//gc<Left><Left><Left> ]] },
    -- { 'x', '<Leader>s', [[ :s/\<<C-r><C-w>\>//g<Left><Left> ]] },
    -- { 'x', '<Leader>sc', [[ :s/\<<C-r><C-w>\>//gc<Left><Left><Left> ]] },

    -- nnoremap <expr> <F8> ':%s/\<'.expand('<cword>').'\>/<&>/g<CR>'
    -- xnoremap <expr> <F8> ':s#\<'.expand('<cword>').'\>#<&>#g<CR>'

    -- ^^^^^^ (4) Replace Last Search ^^^^^^
    -- ^^^^^^ (5) Search and count matched ^^^^^^
    -- ^^^^^^ (6) Search for visual selected text ^^^^^^
    -- ^^^^^^ (7) Replace visual selected text ^^^^^^

    -- { 'n', '<leader>[', [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]] },
    -- { 'n', '<leader>]', [[:s/\<<C-r>=expand("<cword>")<CR>\>/]] },
    -- { 'v', '<leader>[', [["zy:%s/<C-r><C-o>"/]] },
})

-- ^^^^^^ (2) Replace whole word one by one, press . to repeat ^^^^^^
-- Caution: s will conflict with leap.nvim
-- vim.cmd('xnoremap <silent> s* "sy:let @/=@s<CR>cgn')
-- vim.cmd('xnoremap <silent> s) "sycgn')

-- ^^^^^^ (3) Replace the whole word under the cursor ^^^^^^
vim.cmd('nnoremap <Leader>s :%s/\\<<C-r><C-w>\\>//g<Left><Left>')
vim.cmd('nnoremap <Leader>sc :%s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>')
vim.cmd('xnoremap <Leader>s :s/\\<<C-r><C-w>\\>//g<Left><Left>')
vim.cmd('xnoremap <Leader>sc :s/\\<<C-r><C-w>\\>//gc<Left><Left><Left>')

-- ^^^^^^ (4) Replace Last Search ^^^^^^
vim.cmd('nnoremap <Leader>r :%s/\\<<C-r>/\\>//g<Left><Left>')
vim.cmd('nnoremap <Leader>rc :%s/\\<<C-r>/\\>//gc<Left><Left><Left>')
vim.cmd('xnoremap <Leader>r :s/\\<<C-r>/\\>//g<Left><Left>')
vim.cmd('xnoremap <Leader>rc :s/\\<<C-r>/\\>//gc<Left><Left><Left>')

-- ^^^^^^ (5) Search and count ^^^^^^
vim.cmd("nnoremap <expr> * ':%s/'.expand('<cword>').'//gn<CR>``'")

-- ^^^^^^ (6) Search for visual selected text ^^^^^^
vim.cmd("vnoremap // y/\\V<C-R>=escape(@\",'/\\')<CR><CR>")

-- ^^^^^^ (8) Replace visual selected text ^^^^^^
vim.cmd('vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>')


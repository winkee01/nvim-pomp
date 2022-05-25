-- 1. Position the cursor over a word; alternatively, make a selection.
-- 2. Hit cq to start recording the macro.
-- 3. Once you are done with the macro, go back to normal mode.
-- 4. Hit Enter to repeat the macro over search matches.
function v.mappings.setup_CR()
  v.set_keybindings({
    {'n', '<Enter>', [[:nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]] }
  })
end

vim.g.mc = v.replace_termcodes([[y/\V<C-r>=escape(@", '/')<CR><CR>]])

v.set_keybindings({
  {'n', 'Q', '@q'}, -- Q to replay q register

  -- Multiple Cursor Replacement
  -- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
  {'n', 'cn', '*``cgn'},
  {'n', 'cN', '*``cgN'},

  {'x', 'cn', [[g:mc . "``cgn"]], { expr = true, silent = true } },
  {'x', 'cN', [[g:mc . "``cgN"]], { expr = true, silent = true } },
  {'n', 'cq', [[:\<C-u>call v:lua.v.mappings.setup_CR()<CR>*``qz]] },
  {'n', 'cQ', [[:\<C-u>call v:lua.v.mappings.setup_CR()<CR>#``qz]] },
  {'x', 'cq', [[":\<C-u>call v:lua.v.mappings.setup_CR()<CR>gv" . g:mc . "``qz"]], { expr = true} },
  {'x', 'cQ', [[":\<C-u>call v:lua.v.mappings.setup_CR()<CR>gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]], { expr = true } },
})

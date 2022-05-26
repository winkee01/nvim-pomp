setlocal nonumber norelativenumber nolist
setlocal colorcolumn=
setlocal concealcursor=nc

""---------------------------------------------------------------------------//
" Credit: Tweekmonster!
""---------------------------------------------------------------------------//
" if this is a vim help file
" add mappings otherwise do not
if expand('%') =~# '^'.$VIMRUNTIME || &readonly
  " TODO: if buftype is dashboard, use full screen to show help
  autocmd BufWinEnter <buffer> wincmd L | vertical  " We don't need resize here, because we have set winsize in au AutoResize
  " autocmd BufWinEnter <buffer> wincmd L | vertical resize 70
  nnoremap <buffer> q :<c-u>q<cr>
  nnoremap <buffer> <CR> <C-]>
  nnoremap <buffer> <BS> <C-T>
  nnoremap <silent><buffer> o /'\l\{2,\}'<CR>
  nnoremap <silent><buffer> O ?'\l\{2,\}'<CR>
  nnoremap <silent><buffer> s /\|\zs\S\+\ze\|<CR>
  nnoremap <silent><buffer> S ?\|\zs\S\+\ze\|<CR>
  finish
else
  setlocal spell spelllang=en_us
endif

setlocal formatexpr=HelpFormatExpr()

nnoremap <silent><buffer> <leader>r :<c-u>call <sid>right_align()<cr>
nnoremap <silent><buffer> <leader>ml maGovim:tw=78:ts=8:noet:ft=help:norl:<esc>`a

if exists('*HelpFormatExpr')
  finish
endif


function! s:right_align() abort
  let text = matchstr(getline('.'), '^\s*\zs.\+\ze\s*$')
  let remainder = (&l:textwidth + 1) - len(text)
  call setline(line('.'), repeat(' ', remainder).text)
  undojoin
endfunction


function! HelpFormatExpr() abort
  if mode() ==# 'i' || v:char != ''
    return 1
  endif

  let line = getline(v:lnum)
  if line =~# '^=\+$'
    normal! macc
    normal! 78i=
    normal! `a
    undojoin
    return
  elseif line =~# '^\k\%(\k\|\s\)\+\s*\*\%(\k\|-\)\+\*\s*'
    let [header, link] = split(line, '^\k\%(\k\|\s\)\+\zs\s*')
    let header = substitute(header, '^\_s*\|\_s*$', '', 'g')
    let remainder = (&l:textwidth + 1) - len(header) - len(link)
    let line = header.repeat(' ', remainder).link
    call setline(v:lnum, line)
    return
  endif

  return 1
endfunction

" next help tag
nnoremap <silent><buffer> zl :call search('<Bar>[^ <Bar>]\+<Bar>\<Bar>''[A-Za-z0-9_-]\{2,}''')<cr>
" previous help tag
nnoremap <silent><buffer> zh :call search('<Bar>[^ <Bar>]\+<Bar>\<Bar>''[A-Za-z0-9_-]\{2,}''','b')<cr>
" follow tag
nnoremap <buffer> <CR> <C-]>
" back to tag
nnoremap <buffer> <BS> <C-T>

" nnoremap <space>bl :lua vim.api.nvim_buf_set_option(0, 'buflisted', not vim.api.nvim_buf_get_option(0, 'buflisted'))<CR>


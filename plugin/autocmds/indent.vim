" two spaces for selected filetypes
au FileType xml,html,xhtml,css,scssjavascript,lua,dart setlocal shiftwidth=2 tabstop=2
au BufEnter *.json set ai expandtab shiftwidth=2 tabstop=2 sta fo=croql
au FileType text,markdown,tex setlocal textwidth=80
if not vim.filetype then
  return
end

vim.g.do_filetype_lua = 1

vim.filetype.add({
  extension = {
    lock = 'yaml',
    log = 'log',
    ms = 'groff',
  },
  filename = {
    ['.gitignore'] = 'conf',
    Podfile = 'ruby',
    Brewfile = 'ruby',
  },
  pattern = {
    ['*.gradle'] = 'groovy',
    ['*.env.*'] = 'env',
    ['.*aliases'] = 'sh',
  },
})

-- See :h skeleton
v.augroup('Templates', {
  {
    event = { 'BufNewFile' },
    pattern = { '*.sh' },
    command = '0r $HOME/.config/nvim/templates/skeleton.sh',
  },
  {
    event = { 'BufNewFile' },
    pattern = { '*.lua' },
    command = '0r $HOME/.config/nvim/templates/skeleton.lua',
  },
})
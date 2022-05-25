local navigator = require('Navigator')

navigator.setup({ disable_on_zoom = true })

-- Ctrl + hjkl to navigate between vim windows and tmux planes
v.set_keybindings({
    { 'n', '<C-h>', navigator.left },
    { 'n', '<C-j>', navigator.down },
    { 'n', '<C-k>', navigator.up },
    { 'n', '<C-l>', navigator.right },
})


return function()
    require('nvim-gps').setup({
        icons = {
            ['class-name']     = 'ﴯ ',
            ['function-name']  = ' ',
            ['method-name']    = ' ',
            ['container-name'] = '⛶ ',
        },
        languages = {
            html = false,
        },
        separator = ' > ',
    })
end
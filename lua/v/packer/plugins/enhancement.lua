local M = {
    { 
        'psliwka/vim-dirtytalk', 
        run = ':DirtytalkUpdate', 
        config = function() 
            vim.opt.spelllang:append('programming') 
        end 
    },
}

return M

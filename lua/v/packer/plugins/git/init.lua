-- TODO: https://github.com/pwntester/octo.nvim
local conf = v.conf_mod('git')

local M = {
    {
      'ruifm/gitlinker.nvim',
      requires = 'plenary.nvim',
      keys = { '<localleader>gu', '<localleader>go' },
      -- setup = function()
      --   require('which-key').register(
      --     { gu = 'gitlinker: get line url', go = 'gitlinker: open repo url' },
      --     { prefix = '<localleader>' }
      --   )
      -- end,
      config = function()
        local linker = require('gitlinker')
        linker.setup({ mappings = '<localleader>gu' })
        v.map('n', '<localleader>go', function()
          linker.get_repo_url({ action_callback = require('gitlinker.actions').open_in_browser })
        end, 'gitlinker: open in browser')
      end,
    },
    -- git CLI for command mode
    -- TODO: 
    -- something like this would be nice 
    -- https://www.reddit.com/r/neovim/comments/qatokl/using_nvim_as_mergetool_with_vimfugitive/
    {
        'tpope/vim-fugitive',
        requires = {
            'tpope/vim-rhubarb', -- integration with GitHub
            'tommcdo/vim-fubitive', -- integration with BitBucket
        },
        cmd = {
            'Git',
            'GBrowse',
            'Gdiff',
            'Gdiffsplit',
            'Gvdiffsplit',
        },
        keys = {
            '<leader>gd',
            '<leader>gh',
            '<leader>gl',
            '<leader>gg',
            '<Leader>ga',
            { 'v', '<leader>gg' },
        },
    },
    {
        'lewis6991/gitsigns.nvim',
        after = 'plenary.nvim',
        event = 'CursorHold',
        config = conf('gitsigns')
    },
    {
        'sindrets/diffview.nvim',   -- git diff for modified files
        requires = 'nvim-lua/plenary.nvim',
        cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
        module = 'diffview',
        after = 'devicons',
        -- setup = function()
        --     v.map('n', '<localleader>gd', '<Cmd>DiffviewOpen<CR>', 'diffview: diff HEAD')
        -- end,
        config = function()
            require('diffview').setup({
                enhanced_diff_hl = true,
                key_bindings = {
                    file_panel = { q = '<Cmd>DiffviewClose<CR>' },
                    view = { q = '<Cmd>DiffviewClose<CR>' },
                },
            })
        end,
    },
    {
        'akinsho/git-conflict.nvim',
        local_path = 'personal',
        config = function()
            require('git-conflict').setup({
                disable_diagnostics = true,
            })
        end,
    },
    {
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      keys = { '<localleader>gs', '<localleader>gl', '<localleader>gp' },
      requires = 'plenary.nvim',
      setup = conf('neogit').setup,
      config = conf('neogit').config,
    },
    {
      'rlch/github-notifications.nvim',
      -- don't load this plugin if the gh cli is not installed
      requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
      cond = function()
        return v.executable('gh')
      end,
    },
}

return M

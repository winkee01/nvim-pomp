local conf = v.conf_mod('project')

-- Project & Session management
local M = {
    -- ##1## Tree
    {
        'kyazdani42/nvim-tree.lua',
        -- as = 'nvim-tree',
        after = 'devicons',
        -- cmd = {
        --   'NvimTreeToggle',
        --   'NvimTreeFindFile',
        --   'NvimTreeClose',
        -- },
        -- keys = '<Leader>e',
        config = conf('tree')
    },
    -- ranger file explorer
    {
        'kevinhwang91/rnvimr',
        as = 'ranger',
        cmd = 'RnvimrToggle',
        keys = '<Leader>r',
    },

    -- ##2## Dashboard
    {
      'glepnir/dashboard-nvim',
      config = conf('dashboard')
    },

    -- {
    --     'goolord/alpha-nvim', -- a Navigation page like dashboard-nvim
    --     requires = { 'kyazdani42/nvim-web-devicons' },
    -- },

    -- {
    --     'ahmedkhalf/project.nvim',
    --     config = [[ require('plugin-basic/project') ]],
    -- },

    -- ##3## Session
    {
        'rmagatti/auto-session',
        event = 'VimLeavePre',
        cmd = {
            'SaveSession',
            'RestoreSession',
            'DeleteSession',
        },
        keys = { '<Leader>fs' },
        config = function()
            require('auto-session').setup({
              log_level = 'info',
              auto_session_suppress_dirs = { '~/', '~/Projects' },
              auto_session_enable_last_session = false,
              -- auto_restore_enabled = nil,
            })
        end,
    },
    {
      'rmagatti/session-lens',   -- work with glepnir/dashboard-nvim
      cmd = 'SearchSession',
      after = {'telescope.nvim'},
      config = function()
        require"packer".loader("telescope.nvim")
        require("telescope").load_extension("session-lens")
        require('session-lens').setup({
          prompt_title = 'Search Sessions',
          path_display = {'shorten'},
          theme_conf = {border = true},
          previewer = true
        })
      end
    },

    -- {
    --     'airblade/vim-rooter', 
    --     setup = function() 
    --       vim.g.rooter_patterns = NvimMax.plugins.rooter.patterns
    --       -- vim.g.rooter_change_directory_for_non_project_files = ''
    --     end
    -- },
    {
      'notjedi/nvim-rooter.lua',
      config = function()
        require'nvim-rooter'.setup({
          rooter_patterns = {'.git', 'package.json', '_darcs', '.bzr', '.svn', 'Makefile'},
          trigger_patterns = { '*' },
          manual = false,
        })
      end
    },

    -- ##4## Buffer
    {
      'akinsho/bufferline.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      config = conf('bufferline'),
      -- local_path = 'personal',
    },
    { 'kazhala/close-buffers.nvim' },

    -- ##5## Fuzzy
    { 
      'nvim-telescope/telescope.nvim',
      -- cmd = 'Telescope',
      -- keys = { '<c-p>', '<leader>fo', '<leader>ff', '<leader>fs' },
      -- module_pattern = 'telescope.*',
      requires = {
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('fzf')
          end,
        },
        {
          'nvim-telescope/telescope-live-grep-raw.nvim',
          after = 'telescope.nvim',
          opt = true
        },
        {
          'nvim-telescope/telescope-frecency.nvim',
          keys = { "<M>" },
          after = 'telescope.nvim',
          requires = {
            'tami5/sqlite.lua',
            module = "sqlite", 
            opt = true
          },
          config = function()
            local telescope = require("telescope")
            telescope.load_extension("frecency")
            telescope.setup({
              extensions = {
                frecency = {
                  show_scores = false,
                  show_unindexed = true,
                  ignore_patterns = { "*.git/*", "*/tmp/*" },
                  disable_devicons = false,
                  workspaces = {
                    -- ["conf"] = "/home/my_username/.config",
                    -- ["data"] = "/home/my_username/.local/share",
                    -- ["project"] = "/home/my_username/projects",
                    -- ["wiki"] = "/home/my_username/wiki"
                  },
                },
              },
            })
            -- v.map("n", "<leader><leader>p", "<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>", {noremap = true, silent = true})
          end,
        },
        {
          'nvim-telescope/telescope-smart-history.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('smart_history')
          end,
        },
        {
            'crispgm/telescope-heading.nvim', -- markdown header picker
            after = 'telescope.nvim',
        }, 
        -- { 'nvim-lua/popup.nvim' },
        -- { 'nvim-lua/plenary.nvim' },
        -- { 'yamatsum/nvim-nonicons' },
        -- { 'kyazdani42/nvim-web-devicons' }
      },
      config = conf('telescope'),
    },

    -- ##6## Quickfix list
    {
      'https://gitlab.com/yorickpeterse/nvim-pqf',
      event = 'BufReadPre',
      config = function()
        require('v.utils.highlights').set_hi_plugin('pqf', { qfPosition = { link = 'Tag' } })
        require('pqf').setup({})
      end,
    },

    {
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      config = function()
        require('as.highlights').set_hi_plugin('bqf', { BqfPreviewBorder = { foreground = 'Gray' } })
      end,
    },

    -- ##7## Terminal
    {
      'akinsho/toggleterm.nvim',
      -- local_path = 'personal',
      config = conf('toggleterm'),
    },

    -- ##8## Plugin developement & Config reloading
    {
      'klen/nvim-config-local',
      config = function()
        require('config-local').setup({
          config_files = { '.localrc.lua', '.vimrc', '.vimrc.lua' },
        })
      end,
    },
    { 'tami5/sqlite.lua' }, -- sudo apt install libsqlite3-dev

}

return M

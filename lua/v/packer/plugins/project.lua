-- Project & Session management
local M = {
    -- 1. Dashboard
    {
      'glepnir/dashboard-nvim',
    },

    -- {
    --     'goolord/alpha-nvim', -- a Navigation page like dashboard-nvim
    --     requires = { 'kyazdani42/nvim-web-devicons' },
    -- }

    -- {
    --     'ahmedkhalf/project.nvim',
    --     config = [[ require('plugin-basic/project') ]],
    -- )

    -- 2. Session
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
    -- {
    --   'rmagatti/session-lens',   -- work with glepnir/dashboard-nvim
    --   config = function()
    --     require('session-lens').setup({
    --       prompt_title = 'Search Sessions',
    --     })
    --   end
    -- },

    -- {
    --     'airblade/vim-rooter', 
    --     setup = function() 
    --       vim.g.rooter_patterns = NvimMax.plugins.rooter.patterns
    --       -- vim.g.rooter_change_directory_for_non_project_files = ''
    --     end
    -- }
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

    -- 3. Buffer
    { 'kazhala/close-buffers.nvim' },

    -- 4. Fuzzy
    { 
      'nvim-telescope/telescope.nvim',
      cmd = 'Telescope',
      keys = { '<c-p>', '<leader>fo', '<leader>ff', '<leader>fs' },
      module_pattern = 'telescope.*',
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
          'nvim-telescope/telescope-frecency.nvim',
          after = 'telescope.nvim',
          requires = 'tami5/sqlite.lua',
        },
        {
          'nvim-telescope/telescope-smart-history.nvim',
          after = 'telescope.nvim',
          config = function()
            require('telescope').load_extension('smart_history')
          end,
        },
      },
      -- config = conf('telescope'),
    },

    -- 5. Load config
    {
      'klen/nvim-config-local',
      config = function()
        require('config-local').setup({
          config_files = { '.localrc.lua', '.vimrc', '.vimrc.lua' },
        })
      end,
    },
}

return M

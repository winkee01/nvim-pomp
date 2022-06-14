-- Notice:
-- This file is not used, and serves only as an example/reference of how packer is used
-- If you want to use this file, you can require it in root dir's init.lua
local utils = require('v.utils.packer')

local conf = v.conf
local use_local = utils.use_local
local packer_notify = utils.packer_notify

local fn = vim.fn
local fmt = string.format

local PACKER_COMPILED_PATH = fn.stdpath('cache') .. '/packer/packer_compiled.lua'


local appearance = v.conf_mod('appearance')
local enhancement = v.conf_mod('enhancement')
local project = v.conf_mod('project')
local git = v.conf_mod('git')
local language = v.conf_mod('language')
local lsp = v.conf_mod('lsp')

-----------------------------------------------------------------------------//
-- Bootstrap Packer {{{3
-----------------------------------------------------------------------------//
utils.bootstrap_packer()
----------------------------------------------------------------------------- }}}1
-- cfilter is a default plugin provided by default ($RUNTIME/pack/dist/opt/cfilter)
-- it allows filter down an existing quickfix list
vim.cmd('packadd! cfilter')

---@see: https://github.com/lewis6991/impatient.nvim/issues/35
-- bootstrap_packer() has executed packer.sync(), so it's ok to do require here
v.safe_require('impatient')

local packer = require('packer')
--- NOTE "use" functions cannot call *upvalues* i.e. the functions
--- passed to setup or config etc. cannot reference aliased functions
--- or local variables
packer.startup({
  function(use, use_rocks)
    -----------------------------------------------------------------------------//
    -- 1. Basic
    -----------------------------------------------------------------------------//
    -- FIXME: this no longer loads the local plugin since the compiled file now
    -- loads packer.nvim so the local alias(local-packer) does not work
    use_local{ 'wbthomason/packer.nvim', local_path = 'contributing',opt = true}
    -- TODO: use {'lewis6991/impatient.nvim', rocks = 'mpack'}
    use{ 'lewis6991/impatient.nvim' } -- improve startup time
    use{ 'dstein64/vim-startuptime', cmd = 'StartupTime' } -- startup profiling
    use{ 'antoinemadec/FixCursorHold.nvim' } -- fixes CursorHold and CursorHoldl
    use{ 'nvim-lua/plenary.nvim' } -- great utility lua functions
    use { 'penlight', use = 'use_rocks'}

    -----------------------------------------------------------------------------//
    -- 2. Appearance
    -----------------------------------------------------------------------------//
    use{ 'kyazdani42/nvim-web-devicons', as = 'devicons'} -- colored icons
    use{
        'SmiteshP/nvim-gps',    -- show cursor context in statusline
        requires = 'nvim-treesitter/nvim-treesitter',
        after = 'nvim-treesitter',
        config = appearance('gps'),
        -- config = function()
        --     require('nvim-gps').setup({
        --     icons = {
        --         ['class-name']     = 'ﴯ ',
        --         ['function-name']  = ' ',
        --         ['method-name']    = ' ',
        --         ['container-name'] = '⛶ ',
        --     },
        --     languages = {
        --         html = false,
        --     },
        --     separator = ' > ',
        -- })
        -- end,
    },
    
    use{ 'b0o/incline.nvim', config = appearance('incline')}
    use{
        'lukas-reineke/indent-blankline.nvim',
        after = 'nvim-treesitter',
        config = appearance('indent-blankline'),
    }
    use{
        'lukas-reineke/virt-column.nvim',  -- use a char to display colorcolumn
        disable = true,
        event = {
            'CursorHold',
            'CursorMoved',
        },
        config = appearance('virt-column')
    }
    use{ 'rcarriga/nvim-notify' } -- beautiful notifications
    use{ 'kwkarlwang/bufresize.nvim' } -- preserve window sizes on terminal resize
    -- use{
    --   'simeji/winresizer', -- resize mode
    --   setup = function()
    --     vim.g.winresizer_start_key = '<leader>wr'
    --   end,
    -- },

    use{ 'crispgm/nvim-tabline' } -- display opened tabs (2+)
    use{ 'stevearc/dressing.nvim', after = 'telescope.nvim', config = appearance('dressing') } -- improve vim.ui

    -- Make Color Code display color
    -- DEPENDENCY: Golang
    use{
        'RRethy/vim-hexokinase',
        event = 'CursorHold',
        run = 'make hexokinase',
    }

    -- Status Line
    use{
        'nvim-lualine/lualine.nvim',
        after = { 'devicons' },
        -- local_path = 'personal',
        config = appearance('lualine'),
    }
    -- use {
    --   'winkee01/galaxyline.nvim',
    --   -- requires = 'SmiteshP/nvim-gps',
    --   config = appearance('galaxyline'),
    --   diable = true,
    -- }
    use{
      'lewis6991/satellite.nvim', -- displays decorated scrollbars.
      config = appearance('satellite'),
      -- config = function()
      --   require('satellite').setup()
      -- end,
    }

    -----------------------------------------------------------------------------//
    -- 3. Theme
    -----------------------------------------------------------------------------//
    use{ 'NTBBloodbath/doom-one.nvim' } -- DoomEmacs' One
    use{ 'navarasu/onedark.nvim' }
    use{ 'folke/tokyonight.nvim' }
    use{ 'shaunsingh/nord.nvim' }
    use{ 'ishan9299/nvim-solarized-lua' }
    use{ 'Th3Whit3Wolf/space-nvim' } -- SpaceEmacs
    use{ 'marko-cerovac/material.nvim' } -- Material Design-based
    use{ 'olimorris/onedarkpro.nvim' }
    use{ 'rmehri01/onenord.nvim' } -- mix between OneDark and Nord
    use{ 'mrjones2014/lighthaus.nvim' }
    use{ 'rebelot/kanagawa.nvim' }
    use{ 'p00f/alabaster_dark.nvim' } -- also https://git.sr.ht/~p00f/alabaster_dark.nvim
    use{ 'sainnhe/sonokai' } -- high contrast colorscheme
    use{ 'shawncplus/skittles_berry' } -- Slightly higher contrast, brighter

    -----------------------------------------------------------------------------//
    -- 4. Enhancement
    -----------------------------------------------------------------------------//
    -- ##1## motion
    use{
        'ggandor/lightspeed.nvim',
        keys = { '<C-s>', '<C-S-s>' },
    }
    -- { 'chaoren/vim-wordmotion' }, -- problem with statusline mode display

    -- ##2## View
    use{
        'andymass/vim-matchup',  -- make % smarter
        event = {
            'CursorHold',
            'CursorMoved',
        },
        keys = {
            '%',
            'g%',
            '[%',
            ']%',
            'z%',
        },
    }
    use{
      'declancm/cinnamon.nvim', -- NOTE: alternative: 'karb94/neoscroll.nvim'
      config = enhancement('cinnamon')
      -- config = function()
      --   require('cinnamon').setup({
      --     extra_keymaps = true,
      --     scroll_limit = 50,
      --   })
      -- end,
    }
    use{ 'lfv89/vim-interestingwords' }  -- Highlight different words
    use{ 'AndrewRadev/linediff.vim' }    -- Diff two blocks of code in a tmp buffer
    -- use{ "romainl/vim-cool", event = "VimEnter" }  -- Clear highlight search automatically

    -- Register & marks
    -- use{ 'junegunn/vim-peekaboo' }
    use{
      'tversteeg/registers.nvim', 
      config = function() vim.g.registers_window_border = "single" end
    }
    use{ 'chentau/marks.nvim' }
    use{
        'lucasvianav/vim-unimpaired', -- tpope/vim-unimpaired
        keys = {
            '[',
            ']',
            '<M-k>',
            '<M-j>',
            '<Space><Space>',
            'yo',
        },
    }
    -- pulse cursorline after search (easier to find the cursor)
    use{
        'inside/vim-search-pulse',
        keys = {
            '/',
            '?',
            'n',
            'N',
            '*',
            '#',
        },
    }
    -- Align blocks of code
    -- use{ 'vim-tabular' }
    -- use{
    --     'junegunn/vim-easy-align',
    --     cmd = 'EasyAlign',
    --     keys = '<Leader>a',
    -- }


    -- ##3## Edit
    use{
      'numToStr/Comment.nvim',
      requires = {
        {
          'JoosepAlviste/nvim-ts-context-commentstring',
          module = 'ts_context_commentstring',
        },
      },
      config = enhancement('comment')
    }
    use{ 
      'windwp/nvim-autopairs', 
      event = 'InsertEnter',
      config = function()
        require('nvim-autopairs').setup({
          close_triple_quotes = true,
          check_ts = true,
          ts_config = {
            lua = { 'string' },
            dart = { 'string' },
            javascript = { 'template_string' },
          },
          fast_wrap = {
            map = '<c-e>',
          },
        })
      end,
    }
    -- use{ 'machakann/vim-swap', event = 'VimEnter' } -- swap the position of two function arguments
    use{ 'mizlan/iswap.nvim', event = 'VimEnter' }
    use{ 'chrisbra/NrrwRgn', cmd = { 'NR', 'NUD' } } -- Narrow region: Edit only on selected region
    use{
        'AndrewRadev/splitjoin.vim',
        keys = { 'gS', 'gJ' },
        event = {
            'CursorHold',
            'CursorMoved',
        },
    }
    -- use{ 'max397574/better-escape.nvim', event = 'InsertEnter' } -- better <Esc> with jk
    use{ 'tpope/vim-repeat', keys = '.', fn = 'repeat#set' } -- enables . repeat for plugins
    -- Exchange two words/lines
    -- use{ 'mizlan/iswap.nvim' }
    use{
        'tommcdo/vim-exchange',
        keys = {
            'cx',
            'cxx',
            'cxc',
            { 'v', 'X' },
        },
    }

    -- Surrounding  
    use{ 'ur4ltz/surround.nvim' }
    -- use{
    --     'tpope/vim-surround',
    --     after = 'vim-repeat',
    --     event = { 'CursorMoved', 'CursorHold' },
    -- }

    -- Surround for functions
    -- use{ 'Matt-A-Bennett/vim-surround-funk', config = enhancement('surround-funk') }
    -- use{
    --     'AndrewRadev/dsf.vim',
    --     after = 'vim-surround',
    --     keys = {
    --         'csf',
    --         'dsf',
    --         'dif',
    --         'daf',
    --         'dsnf',
    --         { 'o', 'if' },
    --         { 'o', 'af' },
    --     },
    -- }

    -- Word manipulation utilities
    -- use{
    --     'tpope/vim-abolish',
    --     cmd = { 'Abolish', 'Subvert' },
    --     keys = 'cr',
    --     after = 'vim-repeat',
    -- }

    -- project-wide search and replace
    -- DEPENDENCY: RG, sed
    use{
        'windwp/nvim-spectre',
        after = 'plenary.nvim',
        keys = {
            '<Leader>S',
            { 'v', '<Leader>S' },
        },
    }


    -- ## 4 ## Clipboard
    -- better clipboard
    -- https://github.com/AckslD/nvim-neoclip.lua
    -- https://github.com/bfredl/nvim-miniyank
    -- use{
    --     'svermeulen/vim-easyclip',
    --     event = { 'CursorMoved', 'InsertEnter' },
    --     after = 'vim-repeat',
    -- }
    use{
        'AckslD/nvim-neoclip.lua',
        require = { 'nvim-telescope/telescope.nvim' },
        -- keys = { '<M>' },
        event = { 'CursorMoved', 'InsertEnter' },
        after = 'vim-repeat',
        config = function()
            -- require("v.packer.plugins.telescope")
            require("neoclip").setup({ db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3" })
        end,
    }
    use{
      'kevinhwang91/nvim-hclipboard',
      event = 'InsertCharPre',
      config = function()
        require('hclipboard').start()
      end,
    }

    -- ## 5 ## Text Object
    use{
        'wellle/targets.vim', -- provides great new text objects
        event = {
            'CursorHold',
            'CursorMoved',
        },
    }
    -- custom "indent block" text object
    use{
        'kana/vim-textobj-indent',
        requires = { 'kana/vim-textobj-user' },
        event = 'CursorMoved',
    }

    -- ## 6 ## Utils
    -- { 'folke/which-key.nvim', event = 'CursorHold' }, -- displays a popup with keybindings
    -- use nvim in the browser
    use{
        'glacambre/firenvim',
        run = function()
            vim.fn['firenvim#install'](0)
        end,
        disable = true, -- currently not working
    }

    use{ 'monaqa/dial.nvim' }, -- smartly increase/decrease a number or a date
    use{
      'jghauser/fold-cycle.nvim',
      config = function()
        require('fold-cycle').setup({
            softwrap_movement_fix = false,
        })
        -- v.map('n', '<BS>', [[ :call require('fold-cycle').open() ]] )
      end,
    }

    -- {
    --     'mtth/scratch.vim', -- :Scratch opens a scratch buffer in a new window
    --     -- setup = enhancement('scratch'),
    --     config = enhancement('scratch'),
    -- }
   
    -----------------------------------------------------------------------------//
    -- 5. Project
    -----------------------------------------------------------------------------//
    -- ##1## Tree
    use{
        'kyazdani42/nvim-tree.lua',
        -- as = 'nvim-tree',
        after = 'devicons',
        -- cmd = {
        --   'NvimTreeToggle',
        --   'NvimTreeFindFile',
        --   'NvimTreeClose',
        -- },
        -- keys = '<Leader>e',
        config = project('tree')
    }
    -- ranger file explorer
    use{
        'kevinhwang91/rnvimr',
        as = 'ranger',
        cmd = 'RnvimrToggle',
        keys = '<Leader>r',
    }

    -- ##2## Dashboard
    use{
      'glepnir/dashboard-nvim',
      config = project('dashboard')
    }

    -- use{
    --     'goolord/alpha-nvim', -- a Navigation page like dashboard-nvim
    --     requires = { 'kyazdani42/nvim-web-devicons' },
    -- }

    -- use{
    --     'ahmedkhalf/project.nvim',
    --     config = [[ require('plugin-basic/project') ]],
    -- )

    -- ##3## Session
    use{
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
    }
    use{
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
    }

    -- use{
    --     'airblade/vim-rooter', 
    --     setup = function() 
    --       vim.g.rooter_patterns = NvimMax.plugins.rooter.patterns
    --       -- vim.g.rooter_change_directory_for_non_project_files = ''
    --     end
    -- }
    use{
      'notjedi/nvim-rooter.lua',
      config = function()
        require'nvim-rooter'.setup({
          rooter_patterns = {'.git', 'package.json', '_darcs', '.bzr', '.svn', 'Makefile'},
          trigger_patterns = { '*' },
          manual = false,
        })
      end
    }

    -- ##4## Buffer
    use{
      'akinsho/bufferline.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      config = project('bufferline'),
      -- local_path = 'personal',
    }
    use{ 'kazhala/close-buffers.nvim' }

    -- ##5## Fuzzy
    use{ 
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
      config = project('telescope'),
    }

    -- ##6## Quickfix list
    use{
      'https://gitlab.com/yorickpeterse/nvim-pqf',
      event = 'BufReadPre',
      config = function()
        require('v.utils.highlights').set_hi_plugin('pqf', { qfPosition = { link = 'Tag' } })
        require('pqf').setup({})
      end,
    }

    use{
      'kevinhwang91/nvim-bqf',
      ft = 'qf',
      config = function()
        require('as.highlights').set_hi_plugin('bqf', { BqfPreviewBorder = { foreground = 'Gray' } })
      end,
    }

    -- 6. Terminal
    use{
      'akinsho/toggleterm.nvim',
      -- local_path = 'personal',
      config = project('toggleterm'),
    }

    -- 7. Plugin developement & Config reloading
    use{
      'klen/nvim-config-local',
      config = function()
        require('config-local').setup({
          config_files = { '.localrc.lua', '.vimrc', '.vimrc.lua' },
        })
      end,
    }
    use{ 'tami5/sqlite.lua' } -- sudo apt install libsqlite3-dev

    -----------------------------------------------------------------------------//
    -- 6. Git
    -----------------------------------------------------------------------------//
    use{
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
    }
    -- git CLI for command mode
    -- TODO: 
    -- something like this would be nice 
    -- https://www.reddit.com/r/neovim/comments/qatokl/using_nvim_as_mergetool_with_vimfugitive/
    use{
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
    }
    use{
        'lewis6991/gitsigns.nvim',
        after = 'plenary.nvim',
        event = 'CursorHold',
        config = git('gitsigns')
    }
    use{
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
    }
    use{
        'akinsho/git-conflict.nvim',
        local_path = 'personal',
        config = function()
            require('git-conflict').setup({
                disable_diagnostics = true,
            })
        end,
    }
    use{
      'TimUntersberger/neogit',
      cmd = 'Neogit',
      keys = { '<localleader>gs', '<localleader>gl', '<localleader>gp' },
      requires = 'plenary.nvim',
      setup = git('neogit').setup,
      config = git('neogit').config,
    }
    use{
      'rlch/github-notifications.nvim',
      -- don't load this plugin if the gh cli is not installed
      requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
      cond = function()
        return v.executable('gh')
      end,
    }

    -----------------------------------------------------------------------------//
    -- 7. Language
    -----------------------------------------------------------------------------//
    use{
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        -- config = language('treesitter'),
        local_path = 'contributing',
    }
    use{ 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' } -- colored matching brackets

    -- { 
    --     'David-Kunz/treesitter-unit', -- deal with treesitter units
    --     requires = 'nvim-treesitter/nvim-treesitter',
    --     after = 'nvim-treesitter',
    -- },
    -- { 'nvim-neorg/tree-sitter-norg' },
    use{ 
        'RRethy/nvim-treesitter-endwise',
        config = function()
            require('nvim-treesitter.configs').setup {
            endwise = {
                enable = true,
            },
        }
        end,
    }
    use{ 'nvim-treesitter/nvim-treesitter-textobjects' }
    -- {
    --   'nvim-treesitter/playground',
    --   keys = '<leader>E',
    --   cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
    --   setup = function()
    --     v.map(
    --       '<leader>E',
    --       '<Cmd>TSHighlightCapturesUnderCursor<CR>',
    --       'treesitter: highlight cursor group'
    --     )
    --   end,
    -- },

    -- lua, JSON, ...
    use{ 'folke/lua-dev.nvim', requires = 'nvim-lua/plenary.nvim' } -- see v/plugins-config/lsp/servers/sumneko_lua.lua
    use{ 'b0o/schemastore.nvim' } -- JSON
    -- use{ 'bfredl/nvim-luadev' }

    -- web development
    use{'vuki656/package-info.nvim', requires = 'MunifTanjim/nui.nvim'} -- display npm package info
    -- TODO: emmet_ls
    -- TODO: https://pbs.twimg.com/media/FC6NKbQWEAA6ZLc?format=jpg&name=4096x4096
    use{
        'mattn/emmet-vim',
        ft = {
            'html',
            'vue',
            'javascript.jsx',
            'typescript.tsx',
        },
    }
    use{ 
      'jose-elias-alvarez/nvim-lsp-ts-utils', 
      requires = 'nvim-lua/plenary.nvim',
    }
    use{ 'norcalli/nvim-colorizer.lua' }

    -- golang
    -- use{ 
    --     'ray-x/go.nvim', 
    --     -- require = 'hrsh7th/nvim-cmp',
    --     -- after = 'nvim-lspconfig',
    --     ft = 'go', 
    --     config = language('go')
    -- }

    -- rust
    use{ "simrat39/rust-tools.nvim" }

    -- python
    use{ 'Vimjas/vim-python-pep8-indent', ft = { 'python' } } -- indent follows the PEP8 style
    use{ 'jeetsukumaran/vim-pythonsense', ft = { 'python' } } -- python text object
    -- use{
    --     'GCBallesteros/jupytext.vim',
    --     config = function() language('jupytext') end
    -- }

    use{ 'lervag/vimtex', ft = { 'tex', 'plaintex' } } -- LaTeX
    use{ 'editorconfig/editorconfig-vim' } -- .editorconfig files
    -- { 'fladson/vim-kitty', ft = { 'kitty' } }, -- kitty config

    -- Docs generation
    -- { 'kkoomen/vim-doge' },  -- Generate doc for different languages
    use{
        'heavenshell/vim-jsdoc',
        cmd = { 'JsDoc', 'JsDocFormat' },
        keys = '<Leader>j',
        run = 'make install',
        as = 'jsdoc'
    }
    use{ 'milisims/nvim-luaref', ft = 'lua' } -- lua documentation in :help

    -- Spell
    use{ 
        'psliwka/vim-dirtytalk',  -- spellcheck dictionary for programmers
        run = ':DirtytalkUpdate', 
        config = function() 
            vim.opt.spelllang:append('programming') 
        end 
    }
    -- use{
    --   'lewis6991/spellsitter.nvim',
    --   config = function()
    --     require('spellsitter').setup({ enable = true })
    --   end,
    -- }
    -- markdown previewer in browser
    -- DEPENDENCY: npm
    use{
        'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        run = 'cd app && npm install',
    }
    use{ 'dkarter/bullets.vim', ft = 'markdown' } -- markdown lists
    use{
        'dhruvasagar/vim-table-mode',
        ft = {'markdown'},
        -- NOTE: Setup to run before
        -- setup = language('vim-table-mode'),
        config = language('vim-table-mode')
    }

    use{ 'mboughaba/i3config.vim', ft = 'i3config' } -- i3wm cofig file
    
    use{
      'folke/todo-comments.nvim', -- Highlight TODO keyword in comments
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        -- this plugin is not safe to reload
        if vim.g.packer_compiled_loaded then
          return
        end
        require('todo-comments').setup({
          highlight = {
            exclude = { 'org', 'orgagenda', 'vimwiki', 'markdown' },
          },
        })
        -- v.map('n', '<leader>lt', [[ vim.cmd('TodoTrouble') ]])
      end,
    }

    use{
        'itchyny/vim-highlighturl',
        event = {
            'CursorHold',
            'CursorMoved',
        },
    }

    -- better treesitter highlithing in angular
    use{
        'nvim-treesitter/nvim-treesitter-angular',
        ft = {
            'typescript',
            'javascript',
            'html',
        },
        after = 'nvim-treesitter',
    }

    -- JSON
    -- TODO: can this work with treesitter and LSP?
    use{
        'elzr/vim-json',
        disable = true,
        ft = {
            'json',
            'jsonc',
            'jsonp',
        },
    }

    -- use{
    --   'akinsho/flutter-tools.nvim',
    --   requires = { 'mfussenegger/nvim-dap', 'plenary.nvim' },
    --   -- local_path = 'personal',
    --   config = language('flutter-tools'),
    -- }

    -- { 'dart-lang/dart-vim-plugin' }
    use{ 'mtdl9/vim-log-highlighting' }

    -- better commentstrings based in treesitter
    use{
        'JoosepAlviste/nvim-ts-context-commentstring',
        as = 'context-commentstring',
        -- after = { 'vim-commentary', 'nvim-treesitter' },
    }

    -- autoclose and autoedit html tags
    use{
        'windwp/nvim-ts-autotag',
        ft = {
            'html',
            'vue',
            'javascript.jsx',
            'javascriptreact',
            'typescript.tsx',
            'typescriptreact',
            'markdown',
        },
    }

    -- fix `gf` for some filetypes
    -- use{
    --     'tpope/vim-apathy',
    --     ft = {
    --         'go',
    --         'javascript',
    --         'typescript',
    --         'lua',
    --         'python',
    --         'c',
    --         'cpp',
    --     },
    -- }

    use{
        'danymat/neogen', -- Create annotations
        keys = { '<localleader>nc' },
        requires = {
            'nvim-treesitter/nvim-treesitter',
            -- 'saadparwaiz1/cmp_luasnip',
        },
        module = 'neogen',
        setup = function()
            v.map('n', '<localleader>nc', [[ :call v:lua.require('neogen').generate ]])
        end,
        config = function()
            require('neogen').setup({ snippet_engine = 'luasnip' })
        end,
    }

    -- { 'JuliaEditorSupport/julia-vim' }

    use{
        'chrisbra/csv.vim',
        ft = {'csv'}
    }

    -- Org mode
    -- use{
    --   'vhyrro/neorg',
    --   requires = { 'vhyrro/neorg-telescope', 'max397574/neorg-kanban' },
    --   config = language('neorg'),
    -- },
    -- use{
    --   'nvim-orgmode/orgmode', 
    --   config = function()
    --     require('orgmode').setup{}
    --   end
    -- }
    -- use{
    --   'lukas-reineke/headlines.nvim', -- add background for markdown, vimwiki, or orgmode files
    --   setup = language('headlines').setup,
    --   config = language('headlines').config,
    -- }

    -----------------------------------------------------------------------------//
    -- 8. LSP
    -----------------------------------------------------------------------------//
    -- { 'neovim/nvim-lspconfig', config = lsp('lspconfig') },
    use{
        'williamboman/nvim-lsp-installer',
        requires = { { 'neovim/nvim-lspconfig', config = lsp('lspconfig') } },
        after = 'nvim-lspconfig',
        config = function()
          -- require('v.plugins-config.lsp.lsp.diagnostic') -- apply diagnostic configs
          v.augroup('LspInstallerConfig', {
            {
              event = 'Filetype',
              pattern = 'lsp-installer',
              command = function()
                vim.api.nvim_win_set_config(0, { border = v.style.current.border })
              end,
            },
          })
        end,
        -- config = lsp('lsp-installer'),
    }
    -- use{ 'jose-elias-alvarez/typescript.nvim' }
    -- use{ 'RishabhRD/nvim-lsputils', after = 'nvim-lspconfig' }
    use{
        'lukas-reineke/lsp-format.nvim',
        config = function()
            require('lsp-format').setup({
                go = { exclude = { 'gopls' } },
            })
            v.map('n', '<leader>rd', [[ vim.cmd('FormatToggle') ]])
        end,
    }

    -- use{
    --     'jose-elias-alvarez/null-ls.nvim',
    --     requires = { 'nvim-lua/plenary.nvim' },
    --     config = lsp('null-ls'),
    -- }

    use{ 'folke/lua-dev.nvim', ft = 'lua', as = 'lua-dev' } -- setup LSP for lua-nvim dev
    use{ 'kosayoda/nvim-lightbulb', event = 'CursorHold' } -- indicates code actions
    use{ 'nanotee/sqls.nvim', ft = 'sql' } -- sql commands and code actions

    -- function signature
    use{
        'ray-x/lsp_signature.nvim',
        -- event = 'CursorHold',
        after = 'nvim-lspconfig',
        config = function()
            require('lsp_signature').setup({
                bind = true,
                fix_pos = false,
                auto_close_after = 15, -- close after 15 seconds
                hint_enable = false,
                handler_opts = { border = v.style.current.border },
            })
          end,
    }

    -- nice code actions
    use{
        'weilbith/nvim-code-action-menu',
        key = '<leader>ca',
        disable = true,
    }

    -- code completion + lsp-like functionalities without actual lsp
    -- DEPENDENCY: universal-ctags, ctags
    use{
        'ludovicchabant/vim-gutentags',
        requires = 'skywind3000/gutentags_plus',
        disable = true,
    }

    -- code completion
    use{
        'hrsh7th/nvim-cmp',
        requires = {
            { 'hrsh7th/cmp-nvim-lsp' }, -- nvim-cmp source for LSP
            { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },         -- nvim-cmp source for nvim lua
            { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-calc', after = 'nvim-cmp' },             -- nvim-cmp source for math calculation.
            { 'f3fora/cmp-spell', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
            { 'uga-rosa/cmp-dictionary', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
            { 
                'saadparwaiz1/cmp_luasnip',   -- Snippet engine
                require = 'hrsh7th/nvim-cmp',
                after = 'nvim-cmp',
                event = { 'InsertEnter', 'CmdLineEnter' },
            },
            {
                'petertriho/cmp-git',
                after = 'nvim-cmp',
                config = function()
                  require('cmp_git').setup({ filetypes = { 'gitcommit', 'NeogitCommitMessage' } })
                end,
            },
            {
                'lukas-reineke/cmp-under-comparator',
                event = {
                    'CursorHold',
                    'CursorMoved',
                },
                after = 'nvim-cmp'
            },
            {
                'onsails/lspkind-nvim',
                event = {
                    'CursorHold',
                    'CursorMoved',
                },
            },
        },
        event = { 'InsertEnter', 'CmdLineEnter' },
        config = lsp('cmp'),
    }
    use{
        'L3MON4D3/LuaSnip', 
        require = {
            { 
                'saadparwaiz1/cmp_luasnip',  -- Snippet engine
                require = 'hrsh7th/nvim-cmp',
                event = { 'InsertEnter', 'CmdLineEnter' },
                after = 'nvim-cmp',
            }
        },
        event = { 'InsertEnter', 'CmdLineEnter' },
    }
    use{ 'rafamadriz/friendly-snippets'} -- Snippets written in lua, needs LuaSnip or vsnip engine
    use{ 'honza/vim-snippets' } -- Snippets written in snipmate syntax, needs Ultisnips or LuaSnip/vsnip
    -- { 'SirVer/ultisnips', event = 'InsertEnter' }, -- Snippet engine

    use{ 'tami5/lspsaga.nvim', config = lsp('lspsaga') }

    -- AI coding
    use{
      'tzachar/cmp-tabnine',
      run = './install.sh',
      requires = 'hrsh7th/nvim-cmp',
      -- after = 'cmp-calc'
      config = lsp('tabnine'),
    }
    use{
      'github/copilot.vim',
      config = function()
        vim.g.copilot_no_tab_map = true
        v.map('i', '<Plug>(as-copilot-accept)', "copilot#Accept('<Tab>')", { expr = true })
        v.map('i', '<M-]>', '<Plug>(copilot-next)')
        v.map('i', '<M-[>', '<Plug>(copilot-previous)')
        v.map('i', '<C-\\>', '<Cmd>vertical Copilot panel<CR>')

        vim.g.copilot_filetypes = {
          ['*'] = true,
          gitcommit = false,
          NeogitCommitMessage = false,
          DressingInput = false,
          TelescopePrompt = false,
          ['neo-tree-popup'] = false,
        }
        require('v.utils.highlights').set_hi_plugin('copilot', { CopilotSuggestion = { link = 'Comment' } })
      end,
    }
    use{
        "zbirenbaum/copilot.lua",
        event = {"VimEnter"},
        config = function()
            vim.defer_fn(function()
                require("copilot").setup()
            end, 100)
        end,
    }
    use{
        "zbirenbaum/copilot-cmp", -- should be used with copilot.lua
        after = { "copilot.lua", "nvim-cmp" },
    }
    use{ 
        'vappolinario/cmp-clippy', -- nvim-cmp source implementation of VSCode Clippy extension
    }
    
    -- pretty list for lsp
    use{
        'folke/trouble.nvim',
        after = {
            'devicons',
            'nvim-lspconfig',
            'nvim-lspinstall',
        },
        cmd = 'Trouble',
        disable = true,
    }

    use{ 
        'ray-x/navigator.lua',
        requires = {
            { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
            { 'neovim/nvim-lspconfig' },
        },
    }

    use{
      'j-hui/fidget.nvim',  -- lsp loading progress
      local_path = 'contributing',
      config = function()
        require('fidget').setup({
          text = { spinner = 'moon' },
        })
      end,
    }

    ---------------------------------------------------------------------------------
  end,
  log = { level = 'info' },
  config = {
    max_jobs = 50,
    compile_path = PACKER_COMPILED_PATH,
    display = {
      prompt_border = v.style.current.border,
      open_cmd = 'silent topleft 65vnew',
    },
    git = {
      clone_timeout = 240,
    },
    profile = {
      enable = true,
      threshold = 1,
    },
  },
})

v.command('PackerCompiledEdit', function()
  vim.cmd(fmt('edit %s', PACKER_COMPILED_PATH))
end)

v.command('PackerCompiledDelete', function()
  vim.fn.delete(PACKER_COMPILED_PATH)
  packer_notify(fmt('Deleted %s', PACKER_COMPILED_PATH))
end)

if not vim.g.packer_compiled_loaded and vim.loop.fs_stat(PACKER_COMPILED_PATH) then
  v.source(PACKER_COMPILED_PATH)
  vim.g.packer_compiled_loaded = true
end

v.augroup('PackerSetupInit', {
  {
    event = 'BufWritePost',
    pattern = { '*/v/plugins-config/*/*.lua' },
    description = 'Packer setup and reload',
    command = function()
      v.invalidate('v.plugins-config', true)
      packer.compile()
    end,
  },
})

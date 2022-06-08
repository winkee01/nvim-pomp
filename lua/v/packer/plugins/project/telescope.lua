return function()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local layout_actions = require('telescope.actions.layout')
  local themes = require('telescope.themes')
  local H = require('v.utils.highlights')
  local icons = v.style.icons

  H.set_hi_plugin('telescope', {
    TelescopePromptTitle = {
      fg = { from = 'Directory' },
      bold = true,
    },
    TelescopeResultsTitle = {
      fg = { from = 'Normal' },
      bold = true,
    },
    TelescopePreviewTitle = {
      bg = { from = 'LineNr', attr = 'fg' },
      fg = { from = 'Normal' },
      bold = true,
    },

    TelescopePromptPrefix = { link = 'Statement' },
    TelescopeBorder = { foreground = v.style.palette.grey },
    TelescopeMatching = { link = 'Title' },
    TelescopeTitle = { inherit = 'Normal', bold = true },
    TelescopeSelectionCaret = {
      fg = { from = 'Identifier' },
      bg = { from = 'TelescopeSelection' },
    },
  })

  local function rectangular_border(opts)
    return vim.tbl_deep_extend('force', opts or {}, {
      borderchars = {
        prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
        results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
        preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      },
    })
  end

  ---@param opts table?
  ---@return table
  local function dropdown(opts)
    return themes.get_dropdown(rectangular_border(opts))
  end

  local center_dropdown = {
    theme = 'dropdown',
    previewer = false,
    layout_strategy = 'center',
  },

  telescope.setup({
    defaults = {
      -- set_env = { ['TERM'] = vim.env.TERM },
      set_env = { ['COLORTERM'] = 'truecolor' },
      path_display = { 'smart', 'absolute', 'truncate' },

      borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      dynamic_preview_title = true,
      prompt_prefix = icons.misc.telescope .. ' ',
      selection_caret = icons.misc.chevron_right .. ' ',
      entry_prefix = '   ',
      initial_mode = 'insert',
      color_devicons = true,
      file_ignore_patterns = {
        '%.jpg',
        '%.jpeg',
        '%.png',
        '%.otf',
        '%.ttf',
        '%.eot',
        '%.svg',
        '%.DS_Store'
      },
      mappings = {
        i = {
          ['<C-k>'] = actions.move_selection_previous,
          ['<C-j>'] = actions.move_selection_next,
          ['<Esc>'] = actions.close,
          ['<C-v>'] = actions.file_vsplit,
          ['<C-h>'] = actions.file_split,
          ['<C-s>'] = actions.file_split,
          ['<C-y>'] = actions.toggle_selection,
          ['<C-a>'] = actions.select_all,
          ['<M-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
          ['<M-C-Q>'] = actions.smart_send_to_qflist + actions.open_qflist,
          ['<TAB>'] = actions.toggle_selection + actions.move_selection_next,
          ['<S-TAB>'] = actions.toggle_selection + actions.move_selection_previous,
        },

        n = {
          ['<C-k>'] = actions.move_selection_previous,
          ['<C-j>'] = actions.move_selection_next,
          ['<C-c>'] = actions.close,
          ['q'] = actions.close,
          ['v'] = actions.file_vsplit,
          ['s'] = actions.file_split,
          ['<C-y>'] = actions.toggle_selection,
          ['<C-a>'] = actions.select_all,
          ['<M-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
          ['<M-C-Q>'] = actions.smart_send_to_qflist + actions.open_qflist,
          ['<TAB>'] = actions.toggle_selection + actions.move_selection_next,
          ['<S-TAB>'] = actions.toggle_selection + actions.move_selection_previous,
        },
      },
      layout_strategy = 'flex',
      layout_config = {
        horizontal = {
          preview_width = 0.45,
        },
        cursor = { -- FIXME: this does not change the size of the cursor layout
          width = 0.4,
          height = function(self, _, max_lines)
            local results = #self.finder.results
            return (results <= max_lines and results or max_lines - 10) + 4
          end,
        },
      },
      winblend = 5,
      history = {
        path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      },
    },
    extensions = {
      frecency = {
        workspaces = {
          conf = vim.env.DOTFILES,
          project = vim.env.PROJECTS_DIR,
          wiki = vim.g.wiki_path,
        },
      },
      fzf = {
        override_generic_sorter = true,
        override_file_sorter = true,
      },
    },
    pickers = {
      buffers = dropdown({
        sort_mru = true,
        sort_lastused = true,
        show_all_buffers = true,
        ignore_current_buffer = true,
        previewer = false,
        mappings = {
          i = { ['<c-x>'] = 'delete_buffer' },
          n = { ['<c-x>'] = 'delete_buffer' },
        },
      }),
      oldfiles = dropdown(),
      live_grep = {
        file_ignore_patterns = { '.git/' },
        on_input_filter_cb = function(prompt)
          -- AND operator for live_grep like how fzf handles spaces with wildcards in rg
          return { prompt = prompt:gsub('%s', '.*') }
        end,
      },
      current_buffer_fuzzy_find = dropdown({
        previewer = false,
        shorten_path = false,
      }),
      colorscheme = {
        enable_preview = true,
      },
      find_files = {
        follow = true,
        hidden = true,
        file_ignore_patterns = { '^.git', '^.git/', '^.git/*' },
      },
      git_branches = dropdown(),
      git_commits = {
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
        previewer = false,
        theme = 'dropdown',

        mappings = {
          i = {
            ['<CR>'] = open_in_diff,
            ['<c-o>'] = open_in_diff,
          },

          n = {
            ['<CR>'] = open_in_diff,
          },
        },
      },
      reloader = dropdown(),
    },
    diagnostics = center_dropdown,
  })

  --- NOTE: telescope.builtin must be required after setting up telescope
  --- otherwise the result will be cached without the updates from the setup call
  local builtin = require('telescope.builtin')

  local function project_files(opts)
    if not pcall(builtin.git_files, opts) then
      builtin.find_files(opts)
    end
  end

  local function nvim_config()
    builtin.find_files({
      prompt_title = '= nvim config =',
      results_title = 'Neovim Dotfiles',
      cwd = vim.fn.stdpath('config'),
      file_ignore_patterns = { '.git/.*', 'dotbot/.*' },
    })
  end

  local function dotfiles()
    builtin.find_files({
      prompt_title = '= dotfiles =',
      cwd = vim.g.dotfiles,
    })
  end

  local function find_dotfiles()
    builtin.git_files({
      prompt_title = '= dotfiles =',
      file_ignore_patterns = { 'icons/', 'themes/' },
      cwd = os.getenv('HOME') .. '/dotfiles',
      results_title = 'Dotfiles',
    })
  end

  local function find_in_plugins()
    builtin.find_files({
      prompt_title = '= plugins =',
      cwd = vim.fn.stdpath('data') .. '/site/pack/packer',
    })
  end

  local function grep_last_search()
    local register = vim.fn.getreg('/'):gsub('\\<', ''):gsub('\\>', '')
    if register and register ~= '' then
      builtin.grep_string({
        path_display = { 'shorten' },
        search = register,
      })
    else
      builtin.live_grep()
    end
  end

  local function orgfiles()
    builtin.find_files({
      prompt_title = 'Org',
      cwd = vim.fn.expand('$SYNC_DIR/org/'),
    })
  end

  local function open_in_diff(prompt_bufnr)
    actions.close(prompt_bufnr)
    local commit_hash = state.get_selected_entry().value

    local ok_packer, packer = require('v.utils.packer').get_packer()

    if ok_packer then
      pcall(packer.loader, 'diffview.nvim')
      require('diffview').open(commit_hash .. '~1..' .. commit_hash)
    end
  end

  local function norgfiles()
    builtin.find_files({
      prompt_title = 'Norg',
      cwd = vim.fn.expand('$SYNC_DIR/neorg/'),
    })
  end

  local function frecency()
    telescope.extensions.frecency.frecency(dropdown({
      winblend = 10,
      border = true,
      previewer = false,
      shorten_path = false,
    }))
  end

  local function MRU()
    require('mru').display_cache(dropdown({
      previewer = false,
    }))
  end

  local function MFU()
    require('mru').display_cache(
      vim.tbl_extend('keep', { algorithm = 'mfu' }, dropdown({ previewer = false }))
    )
  end

  local function notifications()
    telescope.extensions.notify.notify(dropdown())
  end

  local function gh_notifications()
    telescope.extensions.ghn.ghn(dropdown())
  end

  local function installed_plugins()
    builtin.find_files({
      prompt_title = '~ plugins ~',
      cwd = vim.fn.stdpath('data') .. '/site/pack/packer',
    })
  end

  -- telescope.load_extension('heading')

  v.set_keybindings({
    -- general
    { 'n', '<Leader>ff', builtin.find_files },
    { 'n', '<Leader>fr', builtin.resume },
    { 'n', '<Leader>fp', builtin.live_grep },
    { 'n', '<Leader>fb', builtin.buffers },
    { 'n', '<Leader>fc', builtin.commands },
    { 'n', '<Leader>fch', builtin.command_history },
    { 'n', '<Leader>fj', builtin.jumplist },

    -- lsp
    { 'n', 'gd', builtin.lsp_definitions },
    { 'n', 'gr', builtin.lsp_references },
    { 'n', 'gi', builtin.lsp_implementations },
    {
      'n',
      '<Leader>fg',
      function()
        builtin.diagnostics({ bufnr = 0 })
      end,
    },
    { 'n', '<Leader>fgw', builtin.diagnostics },

    -- git
    { 'n', '<Leader>gb', builtin.git_branches },
    { 'n', '<Leader>gc', builtin.git_commits },

    -- extensions
    -- { 'n', '<Leader>fh', telescope.extensions.heading.heading },
    {
      'n',
      '<Leader>fs',
      [[<cmd>lua require('telescope').extensions['session-lens'].search_session()<cr>]],
    },

    -- custom functions
    { 'n', '<leader>fn', nvim_config },
    { 'n', '<leader>fk', find_in_plugins },
    { 'n', '<leader>fd', find_dotfiles },
    { 'n', '<leader>f/', grep_last_search },

    -- code actions
    {
      'n',
      '<Leader>ca',
      function()
        vim.lsp.buf.code_action()
      end,
    },
    {
      'v',
      '<Leader>ca',
      function()
        vim.lsp.buf.range_code_action()
      end,
    },
  })
end
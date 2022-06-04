-- TODO: https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/plugins/whichkey.lua
-- TODO: how to not group with multiple keys?

local wk = require('which-key')

wk.setup({
  plugins = {
    marks = true,
    registers = false,
    spelling = { enabled = false },

    -- help for built-in stuff
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = false,
      z = true,
      g = true,
    },
  },

  key_labels = {
    ['<space>'] = 'SPC',
    ['<cr>'] = 'ENT',
    ['<tab>'] = 'TAB',
  },

  icons = {
    breadcrumb = '»', -- shows your active key combo
    separator = '➜', -- used between a key and it's label
    group = '+', -- prepended to a group
  },

  window = {
    border = 'single',
    position = 'bottom',
    margin = { 1, 0, 0, 0 },
    padding = { 2, 2, 2, 2 },
  },

  hidden = {
    '<silent>',
    '<cmd>',
    '<Cmd>',
    '<CR>',
    'call',
    'lua',
    '^:',
    '^ ',
  },

  ignore_missing = true, -- hide mappings with no label
  show_help = true, -- help message on the command line w/ popup visible
  -- triggers = {'<leader>'} -- or specify a list manually
})

local opts = {
  mode = 'n',
  prefix = '<Leader>',
  silent = true,
  noremap = true,
  nowait = true,
}

local mappings = {
  ['<space>'] = 'surround in blanklines',
  a = 'easyalign',
  e = 'nvimtree',
  j = 'jsdoc',
  n = 'hide highlights',
  r = 'ranger',
  S = 'spectre',

  h = { 'split below' },
  -- q = { '<cmd>BufClose<cr>', 'close buffer' },
  v = { 'split right' },

  s = {
    name = '???',
    i = 'Sort imports',
  },

  -- w = {
  --   name = '???',
  --   q = 'buffer :wq',
  -- },

  r = {
    name = '???',
    n = 'rename symbol',
  },

  f = {
    name = 'find',
    ['/'] = 'in current buffer',
    b = 'buffers',
    c = 'commands',
    ch = 'command history',
    e = 'emojis',
    f = 'files',
    g = 'diagnostics',
    gw = 'workspace diagnostics',
    h = 'markdown headings',
    j = 'jumplist',
    p = 'pattern (grep)',
    r = 'file history',
    s = 'sessions',
  },

  g = {
    name = 'git',
    b = 'open in browser (github, bitbucket)',
    c = 'commits',
    s = 'status',
    d = 'merge diff',
    h = 'merge from left (target branch)',
    l = 'merge from right (merge branch)',
    i = 'git blame (info)',
    m = 'git messenger',
  },

  c = {
    name = '???',
    a = 'Code Actions',
  },

  t = {
    name = 'tmux',
    p = 'prompt for command',
    r = 'repeats last command',
    i = 'inspect runner page',
    z = 'zooom tmux pane',
    c = 'clear tmux pane',
    t = 'toggle tmux pane',
  },
}

wk.register(mappings, opts)
if v.plugin_loaded("telescope.nvim") then
  wk.register({
    ['<c-p>'] = { project_files, 'telescope: find files' },
    ['<leader>f'] = {
      name = '+telescope',
      a = { builtins.builtin, 'builtins' },
      b = { builtins.current_buffer_fuzzy_find, 'current buffer fuzzy find' },
      d = { dotfiles, 'dotfiles' },
      f = { builtins.find_files, 'find files' },
      n = { notifications, 'notifications' },
      g = {
        name = '+git',
        c = { builtins.git_commits, 'commits' },
        b = { builtins.git_branches, 'branches' },
        n = { gh_notifications, 'notifications' },
      },
      l = {
        name = '+lsp',
        e = { builtins.lsp_workspace_diagnostics, 'telescope: workspace diagnostics' },
        d = { builtins.lsp_document_symbols, 'telescope: document symbols' },
        s = { builtins.lsp_dynamic_workspace_symbols, 'telescope: workspace symbols' },
      },
      m = { MRU, 'Most recently used files' },
      F = { MFU, 'Most frequently used files' },
      h = { frecency, 'Frecency' },
      c = { nvim_config, 'nvim config' },
      o = { builtins.buffers, 'buffers' },
      p = { installed_plugins, 'plugins' },
      O = { orgfiles, 'org files' },
      N = { norgfiles, 'norg files' },
      R = { builtins.reloader, 'module reloader' },
      r = { builtins.resume, 'resume last picker' },
      s = { builtins.live_grep, 'grep string' },
      ['?'] = { builtins.help_tags, 'help' },
    },
  })
end

-- remove floating window BG
vim.cmd([[ hi! WhichKeyFloat ctermbg=NONE guibg=NONE ]])

-- hides cursorline
v.augroup('WhichKeyStatusLine', {
  {
    event = 'FileType',
    opts = {
      pattern = 'WhichKey',
      command = 'set noruler | autocmd BufLeave <buffer> set ruler',
    },
  },
})

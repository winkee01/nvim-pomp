local treesitter = require('nvim-treesitter.configs')
local parsers = require('nvim-treesitter.parsers')
local rainbow_enabled = { 'dart' }

local enable = { enable = true }
local disable = { enable = false }

local langs = {
  'bash',
  'bibtex',
  'c',
  'comment',
  'cpp',
  'css',
  'dockerfile',
  'graphql',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'jsonc',
  'lua',
  'markdown',
  'python',
  'scss',
  'tsx',
  'typescript',
  'vim',
  'yaml',
}

treesitter.setup({
  -- ensure_installed = 'all',
  ensure_installed = langs,
  ignore_install = { 'phpdoc' }, -- list of parser which cause issues or crashes

  autopairs = enable,
  autotag = enable,
  indent = disable,
  matchup = enable,
  endwise = enable,
  
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      -- mappings for incremental selection (visual mappings)
      init_selection = '<leader>v', -- maps in normal mode to init the node/scope selection
      node_incremental = '<leader>v', -- increment to the upper named parent
      node_decremental = '<leader>V', -- decrement to the previous node
      scope_incremental = '<TAB>', -- increment to the upper scope (as defined in locals.scm)
    },
    -- keymaps = {
    --   init_selection = "<CR>",
    --   node_incremental = "<CR>",
    --   node_decremental = "<BS>", -- does not work
    --   scope_incremental = "<TAB>",
    -- },
  },
  textobjects = {
    lookahead = true,
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aC'] = '@conditional.outer',
        ['iC'] = '@conditional.inner',
        -- FIXME: this is unusable
        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/133 is resolved
        -- ['ax'] = '@comment.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['[w'] = '@parameter.inner',
      },
      swap_previous = {
        [']w'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
    },
    lsp_interop = {
      enable = true,
      border = v.style.current.border,
      peek_definition_code = {
        ['<leader>df'] = '@function.outer',
        ['<leader>dF'] = '@class.outer',
      },
    },
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    disable = vim.tbl_filter(function(p)
      local disable = true
      for _, lang in pairs(rainbow_enabled) do
        if p == lang then
          disable = false
        end
      end
      return disable
    end, parsers.available_parsers()),
    colors = {
      'royalblue3',
      'darkorange3',
      'seagreen3',
      'firebrick',
      'darkorchid3',
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { 'BufWrite', 'CursorHold' },
  },
})

-- NOTE: this is to allow markdown highlighting in octo buffers
local parser_config = parsers.get_parser_configs()
parser_config.markdown.filetype_to_parsername = 'octo'

local indent_on = function()
  treesitter.setup({ indent = { enable = true } })
end

local indent_off = function()
  treesitter.setup({ indent = { enable = true } })
end

-- use treesitter indent module only for React files
v.augroup('ReactIndentTS', {
  { event = 'BufEnter', opts = { pattern = { '*.tsx', '*.jsx' }, callback = indent_on } },
  { event = 'BufLeave', opts = { pattern = { '*.tsx', '*.jsx' }, callback = indent_off } },
})

return function()
  require("toggleterm").setup({
    -- size can be a number or function which is passed to the current terminal
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<leader>t]],
    insert_mappings = false, -- whether or not the open mapping applies in insert mode
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = { 'none' },
    shade_terminals = true,
    shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    persist_size = true,
    -- direction =  'vertical' | 'horizontal' | 'window' | "float",
    direction = 'horizontal',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
      -- The border key is *almost* the same as 'nvim_open_win'
      -- see :h nvim_open_win for details on borders however
      -- the 'curved' border is a custom border type
      -- not natively supported but implemented in this plugin.
      border = 'single', -- | 'double' | 'shadow' | 'curved' | ... other options supported by win open
      -- width = 1,
      -- height = 1,
      -- winblend must be commented, otherwise tokyonight colorscheme will be unusable
      -- winblend = 3,
      highlights = {
        border = 'Normal',
        background = 'Normal',
      },
    },
  })

  function _G.set_terminal_keymaps()
    if vim.fn.mapcheck('jk', 't') ~= '' then
      vim.api.nvim_buf_del_keymap(term.bufnr, 't', 'jk')
      vim.api.nvim_buf_del_keymap(term.bufnr, 't', '<esc>')
    end

    local opts = {noremap = true}
    vim.api.nvim_buf_set_keymap(0, 't', '<ESC>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
  end

  local Terminal = require('toggleterm.terminal').Terminal

  local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    direction = "float",
    float_opts = {
      border = "double",
    },
    -- function to run on opening the terminal
    -- on_open = function(term)
    --   -- vim.cmd("startinsert!")
    --   -- vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
    --   vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    -- end,
    -- on_open = set_terminal_keymaps,
    -- function to run on closing the terminal
    on_close = function(term)
      -- log(term)
      -- vim.cmd("Closing terminal")
    end,
  })

  function _LAZYGIT_TOGGLE()
    lazygit:toggle()
  end

  local node = Terminal:new({ cmd = 'node', hidden = true })
  function _NODE_TOGGLE()
    node:toggle()
  end

  local ncdu = Terminal:new({cmd = "ncdu", hidden = true })
  function _NCDU_TOGGLE()
    ncdu:toggle()
  end

  local htop = Terminal:new({cmd = "htop", hidden = true })
  function _HTOP_TOGGLE()
    htop:toggle()
  end

  local python = Terminal:new({cmd = "python3", hidden = true })
  function _PYTHON_TOGGLE()
    python:toggle()
  end

  vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", {noremap = true, silent = true})

end
return function()
  require('gitsigns').setup({
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,

    signs = {
      add = {
            hl = 'GitSignsAdd',
            text = '+',  -- '▌'
            numhl = 'GitSignsAddNr',
            linehl = 'GitSignsAddLn',
        },
        change = {
            hl = 'GitSignsChange',
            text = '~',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn',
        },
        delete = {
            hl = 'GitSignsDelete',
            text = '_',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn',
        },
        topdelete = {
            hl = 'GitSignsDelete',
            text = '‾',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn',
        },
        changedelete = {
            hl = 'GitSignsChange',
            text = '~',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn',
        },
    },
    -- _threaded_diff = true, -- NOTE: experimental
    current_line_blame = false,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
    },
    current_line_blame_formatter_opts = {
        relative_time = false,
    },
    preview_config = {
      -- Options passed to nvim_open_win
      border = v.style.current.border,
      -- border = 'rounded', -- 'single'
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    on_attach = function()
      local gs = package.loaded.gitsigns

      local function qf_list_modified()
        gs.setqflist('all')
      end

      -- require('which-key').register({
      --   ['<leader>h'] = {
      --     name = '+gitsigns hunk',
      --     u = { gs.undo_stage_hunk, 'undo stage' },
      --     p = { gs.preview_hunk, 'preview current hunk' },
      --   },
      --   ['<localleader>g'] = {
      --     name = '+git',
      --     w = { gs.stage_buffer, 'gitsigns: stage entire buffer' },
      --     r = {
      --       name = '+reset',
      --       e = { gs.reset_buffer, 'gitsigns: reset entire buffer' },
      --     },
      --     b = {
      --       name = '+blame',
      --       l = { gs.blame_line, 'gitsigns: blame current line' },
      --       d = { gs.toggle_word_diff, 'gitsigns: toggle word diff' },
      --     },
      --   },
      --   ['<leader>lm'] = { qf_list_modified, 'gitsigns: list modified in quickfix' },
      -- })

      -- Navigation
      v.set_keybindings {
        {
          'n', 
          '[h', 
          function()
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end,
          { expr = true, desc = 'go to next git hunk' }
        },
        {
          'n', 
          ']h', 
          function()
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end,
          { expr = true, desc = 'go to previous git hunk' }
        },
        {'v', '<leader>hs', 
          function() 
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end
        },
        {'v', '<leader>hr', 
          function() 
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end
        },
        {{'o', 'x'}, 'oh', ':<C-U>Gitsigns select_hunk<CR>'},
        {'n', '<leader>hs', 'gs.stage_hunk', { desc = 'stage current hunk' }},
        {'n', '<leader>hr', 'gs.reset_hunk', { desc = 'reset current hunk' }},
        {'n', '<leader>hb', gs.toggle_current_line_blame, { desc = 'toggle current line blame' }},
        -- { 'n', '<leader>hU', gs.reset_buffer_index },
        -- { 'n', '<leader>hb', gs.toggle_current_line_blame },
        -- { 'n', ']h', "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true } },
        -- { 'n', '[h', "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true } },
        -- { { 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>' },
      }
    end,
  })
end

--[[
 -- Navigation
      map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
      map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

      -- Actions
      map({'n', 'v'}, '<leader>ghs', gs.stage_hunk)
      map({'n', 'v'}, '<leader>ghr', gs.reset_hunk)
      map('n', '<leader>ghS', gs.stage_buffer)
      map('n', '<leader>ghu', gs.undo_stage_hunk)
      map('n', '<leader>ghR', gs.reset_buffer)
      map('n', '<leader>ghp', gs.preview_hunk)
      map('n', '<leader>gm', function() gs.blame_line{full=true} end)
      map('n', '<leader>ghd', gs.diffthis)
      map('n', '<leader>ght', gs.toggle_deleted)

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
]]
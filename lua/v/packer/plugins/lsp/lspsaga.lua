return function()
  local lspsaga = require 'lspsaga'
  lspsaga.init_lsp_saga { -- defaults
    debug = false,
    use_saga_diagnostic_sign = true,
    -- diagnostic sign
    error_sign = "",
    warn_sign = "",
    hint_sign = "",
    infor_sign = "",
    diagnostic_header_icon = "   ",
    -- code action title icon
    code_action_icon = "", -- 💡
    code_action_prompt = {
      enable = true,
      sign = true,
      sign_priority = 40,
      virtual_text = true,
    },
    finder_definition_icon = "  ",
    finder_reference_icon = "  ",
    max_preview_lines = 10,
    finder_action_keys = {
      open = {'o', '<CR>'},
      vsplit = "s",
      split = "i",
      quit = { 'q', "<ESC>"},
      scroll_down = "<C-f>",
      scroll_up = "<C-b>",
    },
    code_action_keys = {
      quit = {'q', '<ESC>', '<C-c>'},
      exec = "<CR>",
    },
    rename_action_keys = {
      quit = {'q', '<ESC>', '<C-c>'},
      exec = "<CR>",
    },
    definition_preview_icon = "  ",
    border_style = "single",
    rename_prompt_prefix = "➤",
    rename_output_qflist = {
      enable = false,
      auto_open_qflist = false,
    },
    server_filetype_map = {},
    diagnostic_prefix_format = "%d. ",
    diagnostic_message_format = "%m %c",
    highlight_prefix = false,
  }

  -- v.set_keybindings({
  --   {'n', 'gr', '<cmd>Lspsaga lsp_finder<CR>'},
  --   {'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>'},
  --   {'n', 'gh', '<cmd>Lspsaga hover_doc<CR>'},
  --   {'n', 'gp', '<cmd>Lspsaga show_line_diagnostics<CR>'},
  --   {'n', 'gj', '<cmd>Lspsaga diagnostic_jump_next<CR>'}, -- ]e
  --   {'n', 'gk', '<cmd>Lspsaga diagnostic_jump_prev<CR>'}, -- [e
  --   {'n', 'rn', '<cmd>Lspsaga rename<CR>'},
  --   {'n', 'ca', '<cmd>Lspsaga code_action<CR>'},
  --   {'v', 'ca', '<cmd>Lspsaga range_code_action<CR>'},
  --   {'n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>'},
  --   {'n', 'gs', '<cmd>Lspsaga signature_help<CR>'},
  -- })
end
-- Install typescript
-- npm install -g typescript typescript-language-server

-- local lspconfig = require 'lspconfig'
-- local keybindings = require 'keybindings_lsp'

local opts = {
  flags = {
    allow_incremental_sync = false,
    debounce_text_changes = 150,
  },
  on_attach = function(client, bufnr)
    -- disable doc formatting, leave it to a specialized plugin
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false


    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({
      debug = false,
      disable_commands = false,
      enable_import_on_completion = false,

      -- import all
      import_all_timeout = 5000, -- ms
      -- lower numbers = higher priority
      import_all_priorities = {
          same_file = 1, -- add to existing import statement
          local_files = 2, -- git files or files with relative path markers
          buffer_content = 3, -- loaded buffer content
          buffers = 4, -- loaded buffer names
      },
      import_all_scan_buffers = 100,
      import_all_select_source = false,
      -- if false will avoid organizing imports
      always_organize_imports = true,

      -- filter diagnostics
      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = {},

      -- inlay hints
      auto_inlay_hints = true,
      inlay_hints_highlight = "Comment",
      inlay_hints_priority = 200, -- priority of the hint extmarks
      inlay_hints_throttle = 150, -- throttle the inlay hint request
      inlay_hints_format = { -- format options for individual hint kind
          Type = {},
          Parameter = {},
          Enum = {},
          -- Example format customization for `Type` kind:
          -- Type = {
          --     highlight = "Comment",
          --     text = function(text)
          --         return "->" .. text:sub(2)
          --     end,
          -- },
      },

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil,
    })

    -- required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)

    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local opt = {noremap = true, silent = true }
    buf_set_keymap("n", "gs", ":TSLspOrganize<CR>", opt)
    buf_set_keymap("n", "gr", ":TSLspRenameFile<CR>", opt)
    buf_set_keymap("n", "gi", ":TSLspImportAll<CR>", opt)
    -- auto format
    vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
  end,
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { 
    "javascript", "javascriptreact", "javascript.jsx", 
    "typescript", "typescriptreact", "typescript.tsx" 
  },
  init_options = { hostInfo = "neovim" },
  -- root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  single_file_support = true
}

return opts
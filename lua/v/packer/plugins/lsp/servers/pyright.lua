-- Install: 
-- pip install pyright
-- npm install -g pyright

local opts = {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        extraPaths = { '.', './*', './**/*', './**/**/*' },
        useImportHeuristic = true,
      }
    }
  },
  flags = {
    debounce_text_changes = 150,
  },
  -- on_attach = function(client, bufnr)
  --   client.server_capabilities.document_formatting = false
  --   client.server_capabilities.document_range_formatting = false
  --   -- client.server_capabilities.document_publish_diagnostics = false
  --   require('keybindings_lsp').mapLSP(function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end)
  --   require('plugin-lsp/diagnostics')
  --   vim.cmd('autocmd BufWritePre <buffer> :silent! lua vim.lsp.buf.formatting_sync()')
  -- end,
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = {"python"},
  single_file_support = true
}

return opts
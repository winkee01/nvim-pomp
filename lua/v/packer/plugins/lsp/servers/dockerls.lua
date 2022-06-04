-- Install: npm install -g dockerfile-language-server-nodejs

-- local lspconfig = require'lspconfig'

local opts = {
  flags = {
    debounce_text_changes = 150,
  },
  -- on_attach = function(client, bufnr)
  --   -- disable doc formatting, leave it to a specialized plugin
  --   client.resolved_capabilities.document_formatting = false
  --   client.resolved_capabilities.document_range_formatting = false
  --   vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
  -- end,
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  -- root_dir = lspconfig.util.root_pattern("Dockerfile"),
}

return opts
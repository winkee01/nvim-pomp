local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }

local opts = {
  settings = {}, -- ignored, clangd uses compile_commands.json
  flags = {
    debounce_text_changes = 150,
  },
  -- on_attach = function(client, bufnr)
  --   -- disable doc formatting, leave it to a specialized plugin
  --   client.resolved_capabilities.document_formatting = false
  --   client.resolved_capabilities.document_range_formatting = false
  --   -- client.resolved_capabilities.offsetEncoding = { "utf-16" }

  --   -- auto format, can leave to null-ls to do the job
  --   -- vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
  -- end,
  cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      -- '--query-driver="/usr/local/opt/gcc-arm-none-eabi-8-2019-q3-update/bin/arm-none-eabi-gcc"'
  },
  filetypes = {"c", "cpp", "objc", "objcpp"},
  capabilities = capabilities
}

return opts
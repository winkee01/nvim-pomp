-- Install: npm i -g bash-language-server

local opts = {
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = function(client, bufnr)
    -- disable doc formatting, leave it to a specialized plugin
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
  end,
  cmd = { "bash-language-server", "start" },
  cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
  filetypes = { "sh" },
}

return opts
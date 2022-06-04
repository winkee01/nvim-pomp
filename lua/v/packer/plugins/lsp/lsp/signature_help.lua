local overridden_signature_help = vim.lsp.with(
  vim.lsp.handlers.signature_help, 
  { border = 'single' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = function(...)
  local buf = overridden_signature_help(...)
  -- TODO: is this correct?
  if buf then
    vim.api.nvim_buf_set_keymap(buf, 'n', 'K', '<cmd>wincmd p<CR>', { noremap = true, silent = true })
  end
end
local overridden_hover = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'single', -- rounded
  focusable = false,
})

vim.lsp.handlers['textDocument/hover'] = function(...)
  local buf = overridden_hover(...)
  -- TODO: close the floating window directly without having to execute wincmd p twice
  if buf then
    vim.api.nvim_buf_set_keymap(buf, 'n', 'K', '<cmd>wincmd p<CR>', { noremap = true, silent = true })
  end
end

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = vim.g.floating_window_border_dark,
})


vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'single', focusable = false, silent = true }
)

vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  vim.notify(result.message, lvl, {
    title = 'LSP | ' .. client.name,
    timeout = 10000,
    keep = function()
      return lvl == 'ERROR' or lvl == 'WARN'
    end,
  })
end

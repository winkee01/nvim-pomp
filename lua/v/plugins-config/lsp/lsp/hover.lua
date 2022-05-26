local overridden_hover = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'single', -- rounded
  focusable = false,
})

vim.lsp.handlers['textDocument/hover'] = function(...)
  local buf = overridden_hover(...)
  -- TODO: close the floating window directly without having to execute wincmd p twice
end

local M = {}

function M.update_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  v.lsp.capabilities = capabilities
end

-- -- Setup some autocmds based on the server_capabilities
-- function M.setup_autocommands(client, bufnr)
--   if client and client.server_capabilities.codeLensProvider then
--     v.augroup('LspCodeLens', {
--       {
--         event = { 'BufEnter', 'CursorHold', 'InsertLeave' },
--         buffer = bufnr,
--         command = function()
--           vim.lsp.codelens.refresh()
--         end,
--       },
--     })
--   end
--   if client and client.server_capabilities.documentHighlightProvider then
--     v.augroup('LspCursorCommands', {
--       {
--         event = { 'CursorHold' },
--         buffer = bufnr,
--         command = function()
--           vim.diagnostic.open_float({ scope = 'line' }, { focus = false })
--         end,
--       },
--       {
--         event = { 'CursorHold', 'CursorHoldI' },
--         buffer = bufnr,
--         description = 'LSP: Document Highlight',
--         command = function()
--           pcall(vim.lsp.buf.document_highlight)
--         end,
--       },
--       {
--         event = 'CursorMoved',
--         description = 'LSP: Document Highlight (Clear)',
--         buffer = bufnr,
--         command = function()
--           vim.lsp.buf.clear_references()
--         end,
--       },
--     })
--   end
-- end

return M
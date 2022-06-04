local M = {}

function M.setup_mappings(client)
  local ok = pcall(require, 'lsp-format')
  local format = ok and '<Cmd>Format<CR>' or vim.lsp.buf.formatting
  local function with_desc(desc)
    return { buffer = 0, desc = desc }
  end

  v.map('n', ']c', vim.diagnostic.goto_prev, with_desc('lsp: go to prev diagnostic'))
  v.map('n', '[c', vim.diagnostic.goto_next, with_desc('lsp: go to next diagnostic'))

  if client.server_capabilities.documentFormattingProvider then
    v.map('n', '<leader>rf', format, with_desc('lsp: format buffer'))
  end

  if client.server_capabilities.codeActionProvider then
    v.map('n', '<leader>ca', vim.lsp.buf.code_action, with_desc('lsp: code action'))
    v.map('x', '<leader>ca', vim.lsp.buf.range_code_action, with_desc('lsp: code action'))
  end

  if client.server_capabilities.definitionProvider then
    v.map('n', 'gd', vim.lsp.buf.definition, with_desc('lsp: definition'))
  end
  if client.server_capabilities.referencesProvider then
    v.map('n', 'gr', vim.lsp.buf.references, with_desc('lsp: references'))
  end
  if client.server_capabilities.hoverProvider then
    v.map('n', 'K', vim.lsp.buf.hover, with_desc('lsp: hover'))
  end

  if client.supports_method('textDocument/prepareCallHierarchy') then
    v.map('n', 'gI', vim.lsp.buf.incoming_calls, with_desc('lsp: incoming calls'))
  end

  if client.server_capabilities.implementationProvider then
    v.map('n', 'gi', vim.lsp.buf.implementation, with_desc('lsp: implementation'))
  end

  if client.server_capabilities.typeDefinitionProvider then
    v.map('n', '<leader>gd', vim.lsp.buf.type_definition, with_desc('lsp: go to type definition'))
  end

  if client.server_capabilities.codeLensProvider then
    v.map('n', '<leader>cl', vim.lsp.codelens.run, with_desc('lsp: run code lens'))
  end

  if client.server_capabilities.renameProvider then
    v.map('n', '<leader>rn', vim.lsp.buf.rename, with_desc('lsp: rename'))
  end
end


-- require('which-key').register({
--   g = {
--     D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to declaration' },
--     d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to definition' },
--     i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Go to implementation' },
--     r = { '<cmd>lua vim.lsp.buf.references()<CR>', 'Go to references' },
--   },
--   K = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover' },
--   ['<C-k>'] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Singature help' },
--   ['<leader>'] = {
--     cr = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename variable' },
--     -- TODO: keybindings
--     D = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Go to type definition' },
--     e = { '<cmd>lua vim.diagnostic.open_float()<CR>', 'Show line diagnostics' },
--     cl = { '<cmd>lua vim.diagnostic.set_loclist()<CR>', 'Set location list' },
--   },
--   ['[d'] = {
--     '<cmd>lua vim.diagnostic.goto_prev({ popup_opts = { border = "single" } })<CR>',
--     'Previous diagnostic',
--   },
--   [']d'] = {
--     '<cmd>lua vim.diagnostic.goto_next({ popup_opts = { border = "single" } })<CR>',
--     'Next diagnostic',
--   },
-- }, {
--   buffer = bufnr,
-- })

return M
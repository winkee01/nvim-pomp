local M = {}

function M.update_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if ok then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end

  v.lsp.capabilities = capabilities
end

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

--- Add lsp autocommands
---@param client table<string, any>
---@param bufnr number
function M.setup_autocommands(client, bufnr)
  if client and client.server_capabilities.codeLensProvider then
    v.augroup('LspCodeLens', {
      {
        event = { 'BufEnter', 'CursorHold', 'InsertLeave' },
        buffer = bufnr,
        command = function()
          vim.lsp.codelens.refresh()
        end,
      },
    })
  end
  if client and client.server_capabilities.documentHighlightProvider then
    v.augroup('LspCursorCommands', {
      {
        event = { 'CursorHold' },
        buffer = bufnr,
        description = 'LSP: Show diagnostic popup window',
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
          }
        end,
        command = function()
          vim.diagnostic.open_float({ scope = 'line' }, { focus = false })
        end,
      },
      {
        event = { 'CursorHold', 'CursorHoldI' },
        buffer = bufnr,
        description = 'LSP: Document Highlight',
        command = function()
          pcall(vim.lsp.buf.document_highlight)
        end,
      },
      {
        event = 'CursorMoved',
        description = 'LSP: Document Highlight (Clear)',
        buffer = bufnr,
        command = function()
          vim.lsp.buf.clear_references()
        end,
      },
    })
  end
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param client table lsp client
function M.setup_mappings(client)
  local ok = pcall(require, 'lsp-format')
  local format = ok and '<Cmd>Format<CR>' or vim.lsp.buf.formatting
  local function with_desc(desc)
    return { buffer = 0, desc = desc }
  end

  -- For simplicity, set mappings at a time
  -- You can also check capabilities before you do the mapping
  -- e.g. 
  -- if client.server_capabilities.documentFormattingProvider then
  --   v.map('n', <leader>rf', format, with_desc('lsp: format buffer'))
  -- end
  -- if client.server_capabilities.codeActionProvider then
  -- if client.server_capabilities.definitionProvider then
  -- if client.server_capabilities.referencesProvider then
  -- if client.server_capabilities.hoverProvider then
  -- if client.supports_method('textDocument/prepareCallHierarchy') then
  -- if client.server_capabilities.implementationProvider then
  -- if client.server_capabilities.typeDefinitionProvider then
  -- if client.server_capabilities.codeLensProvider then
  -- if client.server_capabilities.renameProvider then

  v.set_keybindings({
    {'n', '<leader>rf', format, with_desc('lsp: format buffer')},
    {'n', '<leader>ca', vim.lsp.buf.code_action, with_desc('lsp: code action')},
    {'x', '<leader>ca', vim.lsp.buf.range_code_action, with_desc('lsp: code range action')},
    {'n', 'gd', vim.lsp.buf.definition, with_desc('lsp: definition')},
    {'n', 'gr', vim.lsp.buf.references, with_desc('lsp: references')},
    {'n', 'K', vim.lsp.buf.hover, with_desc('lsp: hover')},
    {'n', 'gi', vim.lsp.buf.implementation, with_desc('lsp: implementation')},
    {'n', 'gI', vim.lsp.buf.incoming_calls, with_desc('lsp: incoming calls')},
    {'n', '<leader>gd', vim.lsp.buf.type_definition, with_desc('lsp: go to type definition')},
    {'n', '<leader>cl', vim.lsp.codelens.run, with_desc('lsp: run code lens')},
    {'n', '<leader>rn', vim.lsp.buf.rename, with_desc('lsp: rename')},

    {'n', ']c', vim.diagnostic.goto_prev, with_desc('lsp: go to prev diagnostic')},
    {'n', '[c', vim.diagnostic.goto_next, with_desc('lsp: go to next diagnostic')},
  })
end

return M

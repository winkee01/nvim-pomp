-- local lspconfig = require 'lspconfig'
-- local onat = require "lsp_signature".on_attach()

function GoImports()
  local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
        else
          print('r.command is: ', r.command)
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
end

local opts = {
  init_options = {
    usePlaceholders = true,
  },
  settings = {
    gopls = {
      allExperiments = true,
      usePlaceholders = true,
      analyses = {
        nilness = true,
        shadow = true,
        unusedparams = true,
        shadow = true,
     },
     staticcheck = true,
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = capabilities,
  -- on_attach = v.lsp.on_attach, -- use global on_attach
  -- on_attach = function(client, bufnr)
    
    -- auto format
    -- vim.cmd('autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting()')
    -- vim.cmd('autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting_sync()')
    -- vim.cmd('autocmd BufWritePre <buffer> vim.lsp.buf.formatting()')
    -- vim.cmd('autocmd BufWritePre *.go lua GoImports(1000)')

    -- signature help
    -- require "lsp_signature".on_attach()

  -- end,
  cmd = { "gopls" },
  filetypes = {"go", "gomod", "gotmpl"},
  -- root_dir = lspconfig.util.root_pattern("go.mod", ".git", "go.work"),
  single_file_support = true,
}

-- opts = vim.tbl_extend("force", opts, { capabilities = capabilities } )
-- opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {}, opts or {})

return opts

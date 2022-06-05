-- Install: yarn global add yaml-language-server

local opts = {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
        -- override a schema to use a specific k8s schema version, e.g. k8s 1.18
        -- ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        -- ["../path/relative/to/file.yml"] = "/.github/workflows/*"
        -- ["/path/from/root/of/project"] = "/.github/workflows/*"
      },
    },
    redhat = {
      telemetry = {
        enabled = false
      }
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
  -- on_attach = function(client, bufnr)
  --   -- disable doc formatting, leave it to a specialized plugin
  --   client.server_capabilities.document_formatting = false
  --   client.server_capabilities.document_range_formatting = false

  --   local function buf_set_keymap(...)
  --     vim.api.nvim_buf_set_keymap(bufnr, ...)
  --   end
  --   require('keybindings_lsp').mapLSP(buf_set_keymap)
  --   -- auto format
  --   vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
  -- end,
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_dir = function(fname)
    return require'lspconfig'.util.find_git_ancestor(fname)
  end,
  single_file_support = true
}

return opts
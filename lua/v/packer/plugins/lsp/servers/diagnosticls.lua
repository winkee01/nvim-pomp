-- Install: npm i -g eslint
local opts = {
  -- cmd = "diagnostic-languageserver",
  filetypes = {"javascript", "javascriptreact", "typescript", "typescriptreact", "css"},
  init_options = {
    filetypes = {
      javascript = "eslint",
      typescript = "eslint",
      javascriptreact = "eslint",
      typescriptreact = "eslint"
    },
    linters = {
      eslint = {
        sourceName = "eslint",
        command = "/usr/local/bin/eslint",
        rootPatterns = {
          ".eslitrc.js",
          "package.json"
        },
        debounce = 100,
        args = {
          "--cache",
          "--stdin",
          "--stdin-filename",
          "%filepath",
          "--format",
          "json"
        },
        parseJson = {
          errorsRoot = "[0].messages",
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${ruleId}]",
          security = "severity"
        },
        securities = {
          [2] = "error",
          [1] = "warning"
        }
      }
    }
  },
  -- on_attach = function(client, bufnr)
  --   -- disable formatting, leave it to specialized formatting plugin
  --   client.resolved_capabilities.document_formatting = false
  --   client.resolved_capabilities.document_range_formatting = false
  --   local function buf_set_keymap(...)
  --     vim.api.nvim_buf_set_keymap(bufnr, ...)
  --   end
  --   -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  --   require("keybindings_lsp").mapLSP(buf_set_keymap)
  --   -- require('v.plugins-config.lsp.lsp.diagnostics')
  --   vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
  -- end,
}

return opts
-- Install
-- wget https://github.com/valentjn/ltex-ls/releases/download/15.2.0/ltex-ls-15.2.0-linux-x64.tar.gz

local opts = {
  settings = {
    ltex = {
        enabled = { "latex", "tex", "bib", "markdown", "text", "txt" },
        diagnosticSeverity = "information",
        setenceCacheSize = 2000,
        additionalRules = {
            enablePickyRules = true,
            motherTongue = "de",
        },
        trace = { server = "verbose" },
        dictionary = {},
        disabledRules = {},
        hiddenFalsePositives = {},
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = function(client, bufnr)
    -- disable doc formatting, leave it to a specialized plugin
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    require('keybindings_lsp').mapLSP(buf_set_keymap)
    -- auto format
    vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
  end,
  cmd = { "ltex-ls" },
  cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
  filetypes = { "bib", "gitcommit", "markdown", "org", "plaintex", "rst", "rnoweb", "tex" }
}

return opts
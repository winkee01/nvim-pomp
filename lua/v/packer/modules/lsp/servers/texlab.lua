-- Install
-- cargo build --release
-- cargo install --git https://github.com/latex-lsp/texlab.git --locked
-- wget https://github.com/latex-lsp/texlab/releases/download/v3.3.2/texlab-x86_64-linux.tar.gz

local opts = {
  settings = {
    texlab = {
      -- auxDirectory = "build/pdf",
      auxDirectory = ".",
      -- rootDirectory = ".",
      bibtexFormatter = "texlab",
      build = {
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        executable = "latexmk",
        forwardSearchAfter = false,
        onSave = false
      },
      chktex = {
        onEdit = true,
        onOpenAndSave = false
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        args = {}
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = false
      }
    }
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
  cmd = { "texlab" },
  filetypes = { "tex", "bib" }
}

return opts
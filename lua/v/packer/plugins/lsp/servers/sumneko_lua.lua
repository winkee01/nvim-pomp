-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')


local function get_lua_runtime()
    local result = {}
    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
        local lua_path = path .. "/lua/"
        if vim.fn.isdirectory(lua_path) then
            result[lua_path] = true
        end
    end
    result[vim.fn.expand "$VIMRUNTIME/lua"] = true
    -- result[vim.fn.expand "~/dev/neovim/src/nvim/lua"] = true

    return result
end

local opts = {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      completion = {
        keywordSnippet = "Disable", -- Replace
        callSnippet = 'Replace'
      },
      diagnostics = {
        enable = true,
        -- Get the language server to recognize the `vim` global
        globals = {
          "vim",
          "describe",
          "it",
          "before_each",
          "after_each",
          "teardown",
          "pending",
          "use",
          -- "Neovim",
          -- "Busted",
          -- "packer",
        },
        workspace = {
            library = get_lua_runtime(),
            maxPreload = 1000,
            preloadFileSize = 1000,
        },
      },
      workspace = {
        ignoreDir = "~/.config/nvim/backups",
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
        -- maxPreload = 10000,
        -- preloadFileSize = 10000,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
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
  -- capabilities = NvimMax.capabilities,
}

-- return function() 
--   ---  NOTE: Allows reading requires and variables between different modules in lua context
--   --- @see https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
--   --- if I ever decide to move away from lua dev then use the above gist
--   local ok, lua_dev = v.safe_require('lua-dev')
--   if not ok then
--     return opts
--   end

--   return lua_dev.setup({
--     library = { plugins = { 'plenary.nvim' } },
--     lspconfig = opts,
--   })
-- end

return opts
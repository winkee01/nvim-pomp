return function()
    v.augroup('LspInstallerConfig', {
      {
        event = 'Filetype',
        pattern = 'lsp-installer',
        command = function()
          vim.api.nvim_win_set_config(0, { border = v.style.current.border })
        end,
      },
    })
    -- local lsp_installer = require('nvim-lsp-installer')
    -- lsp_installer.setup({
    --     ensure_installed = servers,
    --     automatic_installation = true,
    -- })

    -- for _, server in ipairs(servers) do
    --   local config = utils.make_config()

    --   local custom_config_path = 'v.plugins-config.lsp.servers.' .. server
    --   local has_custom_config, custom_config = pcall(require, custom_config_path)

    --   if has_custom_config then
    --     config = vim.tbl_deep_extend('force', config, custom_config)
    --   end

    --   if server == 'sumneko_lua' then
    --     local is_packer_loaded, packer = require('v.utils.packer').get_packer()
    --     if is_packer_loaded then
    --       packer.loader('lua-dev')
    --     end

    --     local luadev_loaded, luadev = pcall(require, 'lua-dev')
    --     if luadev_loaded then
    --       config = luadev.setup({ lspconfig = config })
    --     end
    --   end

    --   require('lspconfig')[server].setup(config)
    -- end

    -- lsp_installer.on_server_ready(function(server)
    --     local default_opts = {
    --         on_attach = function(client, bufnr)
    --             client.server_capabilities.document_formatting = false,
    --             on_attach(client, bufnr)
    --         end,
    --         capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    --     }

    --     local server_opts = v.lsp.servers[server.name] or default_opts
    --     server:setup(server_opts)
    -- end)

    -- local servers = {
    --     "bashls", "jsonls", "pyright", "vuels", "yamlls", "tsserver",
    --     "eslint", "html", "dockerls", "cssls", "prismals", "clangd", "c",
    --     "c++", "cmake", "lua", "vimls", "efm"
    -- }

    -- for _, name in pairs(servers) do
    --     local server_is_found, server = lsp_installer.get_server(name)
    --     if server_is_found then
    --         if not server:is_installed() then
    --             print("Installing " .. name)
    --             server:install()
    --         end
    --     end
    -- end
end
--  ____  ____  _____     ___  _____ _____
-- |  _ \|  _ \|_ _\ \   / / \|_   _| ____|
-- | |_) | |_) || | \ \ / / _ \ | | |  _|
-- |  __/|  _ < | |  \ V / ___ \| | | |___
-- |_|   |_| \_\___|  \_/_/   \_\_| |_____|

local fn = vim.fn
local cmd = vim.api.nvim_command

-- Get local plugin path
local function __get_local_plugin_path(arg)
    local path = arg
    local plugins_dir = os.getenv('HOME') .. '/nvim-plugins/'
    local implicit_path = [[^[^\~/.]\+\|^\[^\/]*$]*$\|^\[^\~/]*]]

    if vim.regex(implicit_path):match_str(path) then
        path = plugins_dir .. path
    end

    return path
end

-- Get plugin name from an item in packer use()
-- Remove:
-- 1) leading path 
-- 2) extension 
-- 3) prefix/sufix of vim or nvim 
-- 4) prefix/sufix of lua
-- examples:
-- kazhala/close-buffers.nvim   --> close-buffers
-- Th3Whit3Wolf/space-nvim      --> space
-- honza/vim-snippets           --> snippets
-- p00f/nvim-ts-rainbow         --> ts-rainbow
-- notjedi/nvim-rooter.lua      --> rooter
-- kyazdani42/nvim-tree.lua     --> tree
-- ishan9299/nvim-solarized-lua --> solarized
local function __get_plugin_name(arg)
    if type(arg) ~= 'string' then
        return
    end

    local name = ''

    local re = {
        leadingPath = [[^.\+\/]], -- matches leading path
        extension = [[\.[^.]\+$]], -- matches trailing extension

        vim = [[[-_]n\?vim\|n\?vim]] .. '[-_]', -- matches "-vim" or "vim-" (also nvim and _)
        lua = [[[-_]n\?lua\|n\?lua]] .. '[-_]', -- matches "-lua" or "lua-" (also _)
    }

    local function subs(regex)
        return fn.substitute(name, re[regex], '', 'g')
    end

    name = arg:lower()
    name = subs('leadingPath')
    name = subs('extension')
    name = subs('vim')
    name = subs('lua')

    return name
end

-- Get config and setup str, e.g.
-- { setup = require('xxx/xxx') }
-- { config = require('xxx/xxx') }
local function __get_config_setup_str(config_path, plugin_name, is_theme)
    if type(config_path) ~= 'string' or type(plugin_name) ~= 'string' then
        return
    end

    local require_str = ([[
        local ok, module = pcall(require, '%s')

        if not ok then
            require('v.utils.log').log(module)
        end
    ]]):format(config_path)

    if is_theme and plugin_name then
        require_str = ([[%s
            local themes = require('%s.themes.themes')
            local colorscheme = themes.colorscheme

            if colorscheme == '%s' then
                vim.api.nvim_command('colorscheme %s')
                themes.post_colorscheme_hook()
            end
        ]]):format(require_str, v.plugins_config_path_root, plugin_name, plugin_name)
    end

    return require_str
end

-- local function __get_config_filepath(plugin_name, plugin_type, category)
--     if type(plugin_name) ~= 'string' or type(plugin_type) ~= 'string' then
--         return
--     end

--     local plugins_config_root_path = 'v.plugins-config.'

--     path = string.format('%s.%s.', plugins_config_root_path, category)

--     return path .. plugin_name
-- end

local function __get_plugin_table(args, category)
    if type(args) == 'string' then
        args = { args }
    end

    if not args or #args == 0 or not args[1] then
        return
    end

    -- args[1] is the first item in plugin table
    -- for example, 
    --[[
    local M = {
        { 'kyazdani42/nvim-web-devicons', as = 'devicons' }, -- args[1] is 'kyazdani42/nvim-web-devicons'
    ]]
    local modified_name = args.as or __get_plugin_name(args[1])
    local is_theme = category == 'themes'
    
    -- Construct config if it is nil (not passed by user)
    if not args.config then
        -- If it is theme, use a shared config (TODO: maybe not)
        -- Otherwise, use plugin specific config
        local config_path = v.conf_path(category)(modified_name)
        local require_str = __get_config_setup_str(config_path, modified_name, is_theme)

        args.config = require_str
    end

    -- Construct setup if it is nil, but use_setup is set to true
    -- if args.use_setup and not args.setup then
    --     local setup_path = v.conf_path(category)(modified_name)
    --     local require_str = __get_config_setup_str(config_path, modified_name, is_theme)
    --     args.setup = require_str
    -- end

    return args
end

local function __load_plugins(plugins, packer)
    for category, plugs in pairs(plugins) do
        for _, args in ipairs(plugs) do
            local plugin = __get_plugin_table(args, category)
            if args and args.use == "use_rocks" then
                packer.use_rocks(plugin)
            else 
                packer.use(plugin)
            end
        end
    end

    -- for _, args in ipairs(themes) do
    --     local theme = __get_plugin_table(args, 'theme')
    --     if args then
    --         packer.use(theme)
    --     end
    -- end
end

--  ____  _   _ ____  _     ___ ____
-- |  _ \| | | | __ )| |   |_ _/ ___|
-- | |_) | | | |  _ \| |    | | |
-- |  __/| |_| | |_) | |___ | | |___
-- |_|    \___/|____/|_____|___\____|

local M = {}

---A thin wrapper around vim.notify to add packer details to the message
---@param msg string
function M.packer_notify(msg, level)
  vim.notify(msg, level, { title = 'Packer' })
end

-- TODO: https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/utils/plugins.lua

M.install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
M.compile_path = fn.stdpath('cache') .. '/packer/packer_compiled.lua'

--- Loads packer.nvim (since it's lazy-loaded) and pcall requires it.
function M.get_packer()
    pcall(cmd, 'packadd packer.nvim')
    local is_loaded, packer = pcall(require, 'packer')

    return is_loaded, packer
end

function M.init(packer)
    -- if not packer then
    --     M.packer_notify('packer is nil')
    --     return
    -- end
    packer.init({
        max_jobs = 50,
        compile_path = M.compile_path,
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end,
            prompt_border = 'single',
        },
        git = {
            clone_timeout = 240,
        },
        profile = {
            enable = true,
            treshold = 1,
        },
        compile_path = M.compile_path,
    })
end

function M.setup_plugins(packer)
    local ok, ps = pcall(require, v.plugins_config_path_root)
    if not ok then
        -- error(ps)
        vim.notify(string.format("failed to require'%s'\n%s", v.plugins_config_path_root, ps))
        return
    end
    __load_plugins(ps, packer)
end

function M.setup(packer)
    M.init(packer)
    M.setup_plugins(packer)
end

function M.is_plugin_loaded(plugin)
    local plugin_list = packer_plugins or {}
    return plugin_list[plugin] and plugin_list[plugin].loaded
end

function M.is_plugin_installed(plugin)
    local plugin_list = packer_plugins or {}
    return plugin_list[plugin]
end

-- Make sure packer is installed on the current machine and load
-- the dev or upstream version depending on if we are at work or not
-- NOTE: install packer as an opt plugin since it's loaded conditionally on my local machine
-- it needs to be installed as optional so the install dir is consistent across machines
function M.bootstrap_packer()
    -- if fn.isdirectory(M.install_path) == 1 then
    if fn.empty(fn.glob(M.install_path)) > 0 then
        M.packer_notify('Downloading packer.nvim...')
        M.packer_notify(
          fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', M.install_path })
        )
        vim.cmd('packadd! packer.nvim')
        -- pcall(vim.cmd, 'packadd packer.nvim')
        local is_loaded, packer = pcall(require, 'packer')
        if is_loaded and packer then
            M.init(packer)
            M.setup_plugins(packer)
            packer.sync()
        else
            vim.api.nvim_notify('Failed to load packer', vim.log.levels.ERROR, { title = 'Packer' })
            return
        end
    else
        -- FIXME: currently development versions of packer do not work
        -- local name = vim.env.DEVELOPING and 'local-packer.nvim' or 'packer.nvim'
        vim.cmd('packadd! packer.nvim')
        local ok, packer = pcall(require, 'packer')
        if ok then
            M.init(packer)
            M.setup_plugins(packer)
        else
            vim.api.nvim_notify('Failed to load packer', vim.log.levels.ERROR, { title = 'Packer' })
        end
        -- pcall(require, 'packer_compiled')
    end
end

return M

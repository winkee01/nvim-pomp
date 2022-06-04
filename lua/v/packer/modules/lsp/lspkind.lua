local lspkind = require('lspkind')



lspkind.init({
    -- default: true
    -- with_text = true,
    -- defines how annotations are shown
    -- default: symbol
    -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
    mode = 'symbol_text',
    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',
    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = ""
    },
})

local M ={}
-- Provide formatting parameters for cmp.lua
M.formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      --mode = 'symbol', -- show only symbol annotations
      -- fields = { 'abbr', 'kind', 'menu' },
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        -- Display cmp source 
        -- vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
        local menu =
        ({
          buffer      = v.style.icons.cmp.Buffer .. " [Buffer]",
          nvim_lsp    = v.style.icons.info.paragraph .." [LSP]",
          vsnip       = v.style.icons.cmp.Snippet .. " [VSnip]",
          ultisnips   = v.style.icons.cmp.Snippet .. " [UltiSnips]",
          luasnip     = v.style.icons.cmp.Snippet .. " [LuaSnip]",
          nvim_lua    = v.style.icons.info.bomb .. " [Lua]",
          cmp_tabnine = v.style.icons.info.light .. " [TabNine]",
          look        = v.style.icons.info.look .. " [Look]",
          path        = v.style.icons.info.folderOpen2 .. " [Path]",
          spell       = v.style.icons.info.spell .. " [Spell]",
          calc        = v.style.icons.info.calculator .. " [Calc]",
          emoji       = v.style.icons.misc.emoji .. " [Emoji]", 
          treesitter  = v.style.icons.info.tree,
          npm         = v.style.icons.info.terminal .. ' [NPM]',
          zsh         = v.style.icons.info.terminal .. ' [ZSH]',
          git         = v.style.icons.info.git .. ' [Git]',
          zsh         = '[Z]',
          neorg       = '[Neorg]',
          dict       = '[Dict]',

        })[entry.source.name]

        if entry.source.name == 'cmp_tabnine' then
          if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
            menu = menu .. '[' .. entry.completion_item.data.detail .. ']'
          end
        end

        local maxwidth = 50
        vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
        vim_item.menu = menu

        return vim_item
      end
    })
}

return M
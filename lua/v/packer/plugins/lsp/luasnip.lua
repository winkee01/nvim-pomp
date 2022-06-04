local luasnip = require('luasnip')
local types = require('luasnip.util.types')
local extras = require('luasnip.extras')
local fmt = require('luasnip.extras.fmt').fmt

luasnip.config.set_config({
  history = false,
  region_check_events = 'CursorMoved,CursorHold,InsertEnter',
  delete_check_events = 'InsertLeave',
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        hl_mode = 'combine',
        virt_text = { { '●', 'Operator' } },
      },
    },
    [types.insertNode] = {
      active = {
        hl_mode = 'combine',
        virt_text = { { '●', 'Type' } },
      },
    },
  },
  enable_autosnippets = true,
  snip_env = {
    fmt = fmt,
    m = extras.match,
    t = luasnip.text_node,
    f = luasnip.function_node,
    c = luasnip.choice_node,
    d = luasnip.dynamic_node,
    i = luasnip.insert_node,
    l = extras.lamda,
    snippet = luasnip.snippet,
  },
})

require("luasnip/loaders/from_lua").lazy_load()
require("luasnip/loaders/from_lua").lazy_load({ paths = {'./snippets/lua'} })

-- require("luasnip/loaders/from_vscode").lazy_load({ paths = { "./my-vscode-snippets" } })
require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip/loaders/from_vscode").lazy_load({paths = { './snippets/vscode' }})
require("luasnip/loaders/from_snipmate").lazy_load()
require("luasnip/loaders/from_snipmate").lazy_load({paths = { './snippets/snipmate' }})

-- winkee01/LuaSnip-snippets.nvim
-- luasnip.snippets = require("luasnip-snippets").load_snippets()


local M = {}

-- check if cursor is at the end of line
local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

M.keymaps = function(cmp)
  return {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- elseif luasnip.expandable() then
      --   luasnip.expand()
      elseif luasnip.jumpable(1) then
        luasnip.jump(1)
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
      "c",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
      "c",
    })
  }
end

return M

-- return function()
--   local luasnip = require("luasnip")

--   luasnip.config.set_config({
--     history = true,
--     -- Update more often, :h events for more info.
--     updateevents = "TextChanged,TextChangedI",
--   })

--   -- require("luasnip/loaders/from_vscode").load()
  
--   -- luasnip.snippets = require("luasnip-snippets").load_snippets()

--   --- <tab> to jump to next snippet's placeholder
--   -- local function on_tab()
--   --   return luasnip.jump(1) and "" or vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
--   -- end

--   --- <s-tab> to jump to next snippet's placeholder
--   -- local function on_s_tab()
--   --   return luasnip.jump(-1) and "" or vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
--   -- end


--   -- mappings.imap("<Tab>", on_tab, { expr = true })
--   -- mappings.smap("<Tab>", on_tab, { expr = true })
--   -- mappings.imap("<S-Tab>", on_s_tab, { expr = true })
--   -- mappings.smap("<S-Tab>", on_s_tab, { expr = true })

-- end

-- Ref
-- https://github.com/NTBBloodbath/doom-nvim/blob/main/lua/doom/utils/mappings.lua
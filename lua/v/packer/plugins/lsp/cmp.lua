return function()
  local cmp = require('cmp')
  local h = require('v.utils.highlights')

  local fn = vim.fn
  local api = vim.api
  local fmt = string.format
  local t = v.replace_termcodes
  local border = v.style.current.border
  local lsp_hls = v.style.lsp.kind_highlights

  -- Make the source information less prominent
  local faded = h.alter_color(h.get_hl('Pmenu', 'bg'), 30)
  local kind_hls = {
    CmpItemAbbr = { foreground = 'fg', background = 'NONE', italic = false, bold = false },
    CmpItemMenu = { foreground = faded, italic = true, bold = false },
    CmpItemAbbrMatch = { foreground = { from = 'Keyword' } },
    CmpItemAbbrDeprecated = { strikethrough = true, inherit = 'Comment' },
    CmpItemAbbrMatchFuzzy = { italic = true, foreground = { from = 'Keyword' } },
  }
  for key, _ in pairs(lsp_hls) do
    kind_hls['CmpItemKind' .. key] = { foreground = { from = lsp_hls[key] } }
  end

  h.set_hi_plugin('Cmp', kind_hls)

  local function tab(fallback)
    local ok, luasnip = v.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_next_item()
    elseif ok and luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end

  local function shift_tab(fallback)
    local ok, luasnip = v.safe_require('luasnip', { silent = true })
    if cmp.visible() then
      cmp.select_prev_item()
    elseif ok and luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end

  local cmp_window = {
    border = border,
    winhighlight = table.concat({
      'Normal:NormalFloat',
      'FloatBorder:FloatBorder',
      'CursorLine:Visual',
      'Search:None',
    }, ','),
  }
  cmp.setup({
    preselect = cmp.PreselectMode.None,
    window = {
      completion = cmp.config.window.bordered(cmp_window),
      documentation = cmp.config.window.bordered(cmp_window),
    },

    -- window = {
    --   completion = {
    --     border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    --     winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
    --     scrollbar = "║",
    --     autocomplete = {
    --       require("cmp.types").cmp.TriggerEvent.InsertEnter,
    --       require("cmp.types").cmp.TriggerEvent.TextChanged,
    --     },
    --   },
    --   documentation = {
    --     border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    --     winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
    --     scrollbar = "║",
    --   },
    -- },
    experimental = {
      ghost_text = true,
    },

    snippet = {
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body)       -- vsnip
        -- vim.fn["UltiSnips#Anon"](args.body)        -- ultisnips
        -- require'snippy'.expand_snippet(args.body)  -- snippy
        require('luasnip').lsp_expand(args.body)      -- luasnip
      end,
    },
    matching = {
      disallow_fuzzy_matching = false,
    },
    -- mapping = vim.tbl_extend('keep', cmp_keymaps, luasnip.keymaps(cmp)),
    mapping = {
      ['<Tab>'] = cmp.mapping(tab, { 'i', 's', 'c' }),
      ['<S-Tab>'] = cmp.mapping(shift_tab, { 'i', 's', 'c' }),
      -- ['<c-h>'] = cmp.mapping(function()
      --   api.nvim_feedkeys(fn['copilot#Accept'](t('<Tab>')), 'n', true)
      -- end),
      ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<C-j>'] = cmp.mapping.select_next_item(),
      -- ['<C-q>'] = cmp.mapping({
      --   i = cmp.mapping.abort(),
      --   c = cmp.mapping.close(),
      -- }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }), -- If nothing is selected don't complete
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    formatting = v.conf_ex('lsp')('lspkind').formatting,
    -- formatting = {
    --   deprecated = true,
    --   fields = { 'abbr', 'kind', 'menu' },
    --   format = function(entry, vim_item)
    --     vim_item.kind = fmt('%s %s', v.style.lsp.codicons[vim_item.kind], vim_item.kind)
    --     vim_item.menu = ({
    --       nvim_lsp = '[LSP]',
    --       nvim_lua = '[Lua]',
    --       emoji = '[Emoji]',
    --       path = '[Path]',
    --       neorg = '[Neorg]',
    --       luasnip = '[LuaSnip]',
    --       dictionary = '[Dict]',
    --       buffer = '[Buf]',
    --       spell = '[SP]',
    --       cmdline = '[Cmd]',
    --       rg = '[Rg]',
    --       git = '[Git]',
    --     })[entry.source.name]
    --     return vim_item
    --   end,
    -- },
    sources = cmp.config.sources({
      { name = 'cmp_tabnine', priority = 9, max_item_count = 3 },
      { name = 'copilot', priority = 9, max_item_count = 3, group_index = 2},
      { 
        name = 'cmp-clippy',
        option = {
          model = "EleutherAI/gpt-neo-2.7B", -- check code clippy vscode repo for options
          key = "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", -- huggingface.co api key
        }
      },
      { name = 'nvim_lsp', priority = 8, },
      { name = 'luasnip' },
      { name = 'path' },
      -- { name = 'buffer', priority = 7, keyword_length = 5      },
      -- { name = 'nvim_lua', priority = 5                        },
      -- { name = 'path',priority = 4                             },
      -- { name = 'calc', priority = 3                            },
      { name = "spell" }

      -- { name = "nvim_lsp_signature_help" },

      -- { name = "vsnip" },
      -- { name = 'luasnip' },
      -- { name = 'ultisnips' },
      -- { name = 'snippy' },
      -- { name = "dictionary", keyword_length = 2 },
    }, {
      {
        name = 'buffer',
        options = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(api.nvim_list_wins()) do
              bufs[api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
      { name = 'spell' },
    }),
  })

  local search_sources = {
    view = { entries = { name = 'custom', selection_order = 'near_cursor' } },
    sources = cmp.config.sources({
      { name = 'nvim_lsp_document_symbol' },
    }, {
      { name = 'buffer' },
    }),
  }

  cmp.setup.cmdline('/', search_sources)
  cmp.setup.cmdline('?', search_sources)
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'cmdline', keyword_pattern = [=[[^[:blank:]\!]*]=] },
      { name = 'path' },
    }),
  })
end

local cmp = require("cmp")
local luasnip = require("plugin-lsp.luasnip")
-- local vsnip = require("plugin-lsp.vsnip")

local cmp_keymaps = {
  ['<C-k>'] = cmp.mapping.select_prev_item(),
  ['<C-j>'] = cmp.mapping.select_next_item(),
  ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-2), { 'i', 'c' }),
  ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(2), { 'i', 'c' }),
  ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
  ['<C-e>'] = cmp.mapping {
    i = cmp.mapping.abort(),
    c = cmp.mapping.close(),
  },
  ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
}

cmp.setup({
  -- specify different snippet source: vsnip, luasnip, ultisnips, snippy
  snippet = {
    expand = function(args)
      -- For `vsnip` users.
      -- vim.fn["vsnip#anonymous"](args.body)

      -- For `luasnip` users.
      require('luasnip').lsp_expand(args.body)

      -- For `ultisnips` users.
      -- vim.fn["UltiSnips#Anon"](args.body)

      -- For `snippy` users.
      -- require'snippy'.expand_snippet(args.body)
    end,
  },
  matching = {
    disallow_fuzzy_matching = true,
  },
  -- cmp source
  sources = cmp.config.sources(
  {
    { name = 'cmp_tabnine', priority = 9, max_item_count = 3 },
    { name = 'luasnip', priority = 7 },
    { name = 'nvim_lsp', priority = 5 },
    -- { name = 'vsnip', priority = 7 },
    { name = 'npm', priority = 6, keyword_length = 4 },
    -- { name = 'buffer', priority = 7, keyword_length = 5      },
    -- { name = 'nvim_lua', priority = 5                        },
    -- { name = 'path',priority = 4                             },
    -- { name = 'calc', priority = 3                            },
    -- { name = "spell" }

    -- { name = "nvim_lsp" },
    -- { name = "nvim_lsp_signature_help" },
    
    -- { name = "vsnip" },
    -- { name = 'luasnip' },
    -- { name = 'ultisnips' },
    -- { name = 'snippy' },
  }),
  formatting = require('plugin-lsp.lspkind').formatting,
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    completion = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      scrollbar = "║",
      autocomplete = {
        require("cmp.types").cmp.TriggerEvent.InsertEnter,
        require("cmp.types").cmp.TriggerEvent.TextChanged,
      },
    },
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      scrollbar = "║",
    },
  },
  experimental = {
    ghost_text = true,
  },
  mapping = vim.tbl_extend('keep', cmp_keymaps, luasnip.keymaps(cmp)),
})

-- buffer cmp for search
cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" },
  },
})

-- path and cmdline cmp to be used in Ex mode
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

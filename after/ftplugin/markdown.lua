vim.opt_local.colorcolumn = "101"
vim.opt.autoindent = true
vim.opt.linebreak = true

-- no distractions in markdown files
vim.opt_local.number = false
vim.opt_local.relativenumber = false

-- @TODOUA:
-- spell is not staying local for some reason
-- have to set nospell in other fts that are opened after a markdown
vim.opt_local.spell = true
vim.opt_local.spelllang = en_US

v.set_keybindings({
    {'o', '<buffer>ih', [[ :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr> ]]},
    {'o', '<buffer>ah', [[ :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr> ]]},
    {'o', '<buffer>aa', [[ :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr> ]]},
    {'o', '<buffer>ia', [[ :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr> ]]},
})

vim.api.nvim_exec(
  [[
iabbrev >> →
iabbrev << ←
iabbrev ^^ ↑
iabbrev VV ↓
]], false)

-- Markdown Preview
-- For Glow, just type :Glow
if v.plugin_loaded("markdown-preview.nvim") then
    vim.cmd('nmap <buffer> <localleader>p <Plug>MarkdownPreviewToggle')
end

if v.plugin_loaded("nvim-treesitter") then
    -- vim.cmd('nmap ,th :TSBufToggle highlight<CR>')
    vim.api.nvim_buf_set_keymap(0, "n", ",th", ":TSBufToggle highlight<CR>", { noremap = false })
end

if v.plugin_loaded("vim-eunuch") then
    vim.api.nvim_exec('nmap <buffer><silent><localleader>rn :Rename<space>', false)
end

if v.plugin_loaded("vim-surround") then
    -- wrap selection in markdown link
    vim.api.nvim_buf_set_keymap(0, "v", ",wl", [[c[<c-r>"]()<esc>]], { noremap = false })

    -- italicize Word - in visual: S{arg}
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>_", "ysiW_", { noremap = false })
end

-- Persist Markdown Folds
v.augroup('PersistMarkdownFolds', {
    {
        event = { 'BufWinEnter' },
        pattern = { '*.md' },
        command = ':silent! loadview'
    },
    {
        event = { 'BufWinLeave' },
        pattern = '*.md',
        command = ':mkview'
    },
})

-- vim.api.nvim_create_augroup("PersistMarkdownFolds", {})
-- vim.api.nvim_create_autocmd("BufWinLeave", { command = "mkview", pattern = "*.md", group = "PersistMarkdownFolds" })
-- vim.api.nvim_create_autocmd(
--   "BufWinEnter",
--   { command = "silent! loadview", pattern = "*.md", group = "PersistMarkdownFolds" }
-- )

-- match and highlight hyperlinks
-- standalone
vim.fn.matchadd("matchURL", [[http[s]\?:\/\/[[:alnum:]%\/_#.-]*]])
vim.cmd("hi matchURL guifg=DodgerBlue")

-- grey out for strikethrough
vim.fn.matchadd("matchStrike", [[[~]\{2}.\+[~]\{2}]])
vim.cmd("hi matchStrike guifg=gray")


if v.plugin_loaded("nvim-cmp") then
    local cmp = require('cmp')
    cmp.setup.filetype('markdown', {
        sources = cmp.config.sources({
            -- { name = 'vsnip' },
            { name = 'dictionary' },
            { name = 'spell' },
            { name = 'emoji' },
            { name = "path" },
        }, {
            { 
                name = 'buffer',
                option = {
                    get_bufnrs = function()
                      -- @TODOUA: Trying out just populate from visible buffers. Keep?
                      local bufs = {}
                      for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                      end
                      return vim.tbl_keys(bufs)
                    end,
                },
            },
        }),
    })
end

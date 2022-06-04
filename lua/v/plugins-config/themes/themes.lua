-- TODO: https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/external.lua
-- TODO: https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/external.lua
-- TODO: https://github.com/akinsho/dotfiles/blob/f714d4cdd2de74c7393ca3ae69bdbb3619e06174/.config/nvim/plugin/autocommands.lua#L158-L187
-- TODO: https://github.com/akinsho/dotfiles/blob/main/tmux/.tmux.conf
-- TODO: https://github.com/akinsho/dotfiles/blob/main/tmux/tmux-status.conf
-- TODO: https://www.reddit.com/r/neovim/comments/r0omlv/start_your_search_from_a_more_comfortable_place/

local o = vim.opt
local fmt = string.format
-- local colors = v.style.theme_colors

local colors = {
  black = '#151515',
  blacker = '#000000',
  blue = '#80a0ff',
  blue_light = '#2496ed',
  cyan = '#519aba',
  cyan_grey = '#4a5274',
  cyan_grey_dark = '#3b4261',
  green = '#98BE65',
  grey = '#282C34', -- #353b45
  grey_dark = '#24272E', -- #292a35
  grey_darker = '#21242B',
  grey_light = '#5a5c68',
  off_black = '#1e1e1e',
  off_white = '#F7F7F7',
  pink_light = '#e535ab',
  red = '#ff5189',
  transparent = '',
  violet = '#d183e8',
  white = '#FFFFFF',
  yellow = '#cbcb41',
}

-- override default colorscheme
local colorscheme =  'doom-one'

local M = {}

M.colorscheme = colorscheme

--- function to be ran after a colorscheme is applied
M.post_colorscheme_hook = function()
  require('v.utils.highlights').set_highlights({
    -- { 'CursorLine', { guibg = colors.cyan_grey_dark } },
    -- { 'ColorColumn', { guibg = colors.cyan_grey_dark } },
    { 'NormalFloat', { link = 'Normal', bang = true } },
    { 'FloatBorder', { 'transparent' } },
    { 'Folded', { 'transparent' } },
    { 'BufferLineFill', { 'transparent' } },
    { 'TabLine', { 'transparent', guifg = colors.cyan_grey } },
    { 'TabLineFill', { 'transparent' } },
    {
      'TabLineSel',
      {
        guibg = colors.grey_dark,
        guifg = colors.off_white,
      },
    },
  })
end


return M

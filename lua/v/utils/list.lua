local utils = require "utils"
local M = {}

local quickfix = "Quickfix"
local location = "Location"

M.setup = function()
    vim.g.active_list = quickfix
end

M.change_active = function(list)
    vim.g.active_list = list
end

M.toggle_active = function()
    vim.g.active_list = utils._if(vim.g.active_list == quickfix, location, quickfix)
    print(string.format("%s list", vim.g.active_list))
end

M.move = function(direction)
    local wrap
    wrap = function(cmd, backup)
        local status = pcall(vim.cmd, cmd)
        if not status then
            wrap(backup, "echo 'No Errors'")
        end
    end

    if direction == "up" then
        if vim.g.active_list == quickfix then
            wrap("cprevious", "clast")
        else
            wrap("labove", "llast")
        end
    elseif direction == "down" then
        if vim.g.active_list == quickfix then
            wrap("cnext", "cfirst")
        else
            wrap("lbelow", "lfirst")
        end
    elseif direction == "left" then
        if vim.g.active_list == quickfix then
            pcall(vim.cmd, [[colder]])
        else
            pcall(vim.cmd, [[lolder]])
        end
    elseif direction == "right" then
        if vim.g.active_list == quickfix then
            pcall(vim.cmd, [[cnewer]])
        else
            pcall(vim.cmd, [[lnewer]])
        end
    end
end

return M


--[[

map("n", "<UP>", ":lua require('v.utils.lists').move('up')<CR>")
map("n", "<DOWN>", ":lua require('v.utils.lists').move('down')<CR>")
map("n", "<LEFT>", ":lua require('v.utils.lists').move('left')<CR>")
map("n", "<RIGHT>", ":lua require('v.utils.lists').move('right')<CR>")
map(
    "n",
    leader .. "c",
    "<Plug>(qf_qf_toggle_stay):lua require('v.utils.lists').change_active('Quickfix')<CR>",
    { noremap = false }
)
map(
    "n",
    leader .. "v",
    "<Plug>(qf_loc_toggle_stay):lua require('v.utils.lists').change_active('Location')<CR>",
    { noremap = false }
)
map("n", leader .. "b", ":lua require('v.utils.lists').toggle_active()<CR>")
map("n", leader .. "a", ":lua require('v.utils.lists').change_active('Quickfix')<CR>:Ack<space>", { silent = false })

]]

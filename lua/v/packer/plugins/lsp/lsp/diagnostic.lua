local icons = v.style.icons.lsp
local fmt = string.format


-- Define custom signs symbols for diagnostics
-- local signs = { Error = "✗", Warn = "", Hint = "", Info = "" }  -- ◉ ● •·
-- local signs = { Error = "  ", Warn = "  ", Hint = "  ", Info = "  " }

-- local function set_signs(signs)
--   for severity, icon in pairs(signs) do
--     local hl = 'Diagnostic' .. severity
--     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
--   end
-- end

-- set_signs(signs)

local diagnostic_types = {
  { 'Error', icon = icons.error },
  { 'Warn', icon = icons.warn },
  { 'Hint', icon = icons.hint },
  { 'Info', icon = icons.info },
}

vim.fn.sign_define(vim.tbl_map(function(t)
  local hl = 'DiagnosticSign' .. t[1]
  return {
    name = hl,
    text = t.icon,
    texthl = hl,
    numhl = fmt('%sNr', hl),
    linehl = fmt('%sLine', hl),
  }
end, diagnostic_types))

-- We can use sign symbols defined in LspSaga (see lspsaga.lua)
-- we can also override LspSaga's default signs using below syntax
-- vim.api.nvim_command [[ sign define LspDiagnosticsSignError         text=✗ texthl=LspDiagnosticsSignError       linehl= numhl= ]]
-- vim.api.nvim_command [[ sign define LspDiagnosticsSignWarning       text=⚠ texthl=LspDiagnosticsSignWarning     linehl= numhl= ]]
-- vim.api.nvim_command [[ sign define LspDiagnosticsSignInformation   text= texthl=LspDiagnosticsSignInformation linehl= numhl= ]]
-- vim.api.nvim_command [[ sign define LspDiagnosticsSignHint          text= texthl=LspDiagnosticsSignHint        linehl= numhl= ]]

vim.diagnostic.config({
  severity_sort = { reverse = true },
  underline = true,
  signs = true,
  -- signs = function(namespace, bufnr)
  --   return vim.b[bufnr].show_signs == true
  -- end
  -- signs = { severity = { min = vim.diagnostic.severity.WARN } },
  update_in_insert = false,
  virtual_text = false,
  -- virtual_text = {
  --   source = "always",  -- Or "if_many"
  --   spacing = 2,
  --   --severity_limit='Error'  -- Only show virtual text on error
  --   prefix = '●', -- Could be '■', ●', '▎', 'x'
  -- },
  float = {
    -- header = false,
    source = "always",  -- Or "if_many"
    focusable = false,
    max_width = vim.g.floating_window_maxwidth,
    max_height = vim.g.floating_window_maxheight,
    border = v.style.current.border,

    format = function(diagnostic)
      if not diagnostic.source or not diagnostic.user_data.lsp.code then
        return string.format('%s', diagnostic.message)
      end

      if diagnostic.source == 'eslint' then
        return string.format('%s [%s]', diagnostic.message, diagnostic.user_data.lsp.code)
      end

      return string.format('%s [%s]', diagnostic.message, diagnostic.source)
    end
  },
})

local function filter(arr, func)
  -- general purpose filter in place
  -- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
  local new_index = 1
  local size_orig = #arr
  for old_index, v in ipairs(arr) do
    if func(v, old_index) then
      arr[new_index] = v
      new_index = new_index + 1
    end
  end
  for i = new_index, size_orig do
    arr[i] = nil
  end
end

-- allow you to mute some diagnostics
local function filter_diagnostics(diagnostic)
  -- only apply filter to Pyright & Pylance
  if not diagnostic.source:find('Py', 1, true) then
    return true
  end
  -- Allow kwargs to be unused
  if diagnostic.message == '"kwargs" is not accessed' then
    return false
  end

  -- prefix variables with an underscore to ignore
  if string.match(diagnostic.message, '"_.+" is not accessed') then
    return false
  end

  return true
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  function(_, params, ctx, config)
    filter(params.diagnostics, filter_diagnostics)
    vim.lsp.diagnostic.on_publish_diagnostics(_, params, ctx, config)
  end,
  {}
  -- pcall(vim.diagnostic.setloclist, { open = false })
)

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
--   vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--       underline = true,
--       update_in_insert = false,
--   })(...)
--   pcall(vim.diagnostic.setloclist, { open = false })
-- end

vim.diagnostic.open_float = (function(orig)
    return function(bufnr, opts)
        local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
        local opts = opts or {}
        -- A more robust solution would check the "scope" value in `opts` to
        -- determine where to get diagnostics from, but if you're only using
        -- this for your own purposes you can make it as simple as you like
        local diagnostics = vim.diagnostic.get(opts.bufnr or 0, {lnum = lnum})
        local max_severity = vim.diagnostic.severity.HINT
        for _, d in ipairs(diagnostics) do
            -- Equality is "less than" based on how the severities are encoded
            if d.severity < max_severity then
                max_severity = d.severity
            end
        end
        local border_color = ({
            [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
            [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
            [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
        })[max_severity]
        opts.border = {
            {"🭽", border_color},
            {"▔", border_color},
            {"🭾", border_color},
            {"▕", border_color},
            {"🭿", border_color},
            {"▁", border_color},
            {"🭼", border_color},
            {"▏", border_color},
        }
        orig(bufnr, opts)
    end
end)(vim.diagnostic.open_float)

-- show diagnostics for current line as virtual text
-- from https://github.com/kristijanhusak/neovim-config/blob/5977ad2c5dd9bfbb7f24b169fef01828717ea9dc/nvim/lua/partials/lsp.lua#L169
local diagnostic_ns = vim.api.nvim_create_namespace 'diagnostics'
function _G.show_diagnostics()
  vim.schedule(function()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
    vim.diagnostic.show(
        diagnostic_ns,
        bufnr,
        diagnostics,
        { virtual_text = true }
    )
  end)
end

-- function _G.show_diagnostics1(pos)
--   local bufnr = vim.api.nvim_get_current_buf()
--   local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
--   local opt = { border = 'single' }
--   if diagnostic.open_float and type(diagnostic.open_float) == 'function' then
--     if pos == true then
--       opt.scope = 'cursor'
--     else
--       opt.scope = 'line'
--     end
--     diagnostic.open_float(bufnr, opt)
--   else
--     -- deprecated
--     diagnostic.show_line_diagnostics(opt, bufnr, lnum)
--   end
-- end

local function source_string(source)
    return string.format("  [%s]", source)
end

-- Get all diagnostics of a line, then process those we are interested in
local function line_diagnostics()
  local bufnr, lnum = unpack(vim.fn.getcurpos())
  local diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, lnum - 1, {})
  if vim.tbl_isempty(diagnostics) then
    return
  end

  local lines = {}
  for _, diagnostic in ipairs(diagnostics) do
    table.insert(
        lines,
        signs[diagnostic.severity]
            .. " "
            .. diagnostic.message:gsub("\n", " ")
            .. source_string(diagnostic.source)
    )
  end

  local floating_bufnr, _ = vim.lsp.util.open_floating_preview(lines, "plaintext", {
    border = vim.g.floating_window_border_dark,
  })

  for i, diagnostic in ipairs(diagnostics) do
    local message_length = #lines[i] - #source_string(diagnostic.source)
    vim.api.nvim_buf_add_highlight(floating_bufnr, -1, serverity_map[diagnostic.severity], i - 1, 0, message_length)
    vim.api.nvim_buf_add_highlight(floating_bufnr, -1, "DiagnosticSource", i - 1, message_length, -1)
  end
end

-- v.map("n", "<Space><CR>", "<cmd>lua line_diagnostics()<CR>", { buffer = true })


-- A helper function to auto-update the quickfix list when new diagnostics come
-- in and close it once everything is resolved. This functionality only runs whilst
-- the list is open.
-- similar functionality is provided by: https://github.com/onsails/diaglist.nvim
local function make_diagnostic_qf_updater()
  local cmd_id = nil
  return function()
    vim.diagnostic.setqflist({ open = false })
    as.toggle_list('quickfix')
    if not as.is_vim_list_open() and cmd_id then
      vim.api.nvim_del_autocmd(cmd_id)
      cmd_id = nil
    end
    if cmd_id then
      return
    end
    cmd_id = api.nvim_create_autocmd('DiagnosticChanged', {
      callback = function()
        if as.is_vim_list_open() then
          vim.diagnostic.setqflist({ open = false })
          if #vim.fn.getqflist() == 0 then
            v.toggle_list('quickfix')
          end
        end
      end,
    })
  end
end

-- v.run_command('LspDiagnostics', make_diagnostic_qf_updater())
-- v.map('n', '<leader>ll', '<Cmd>LspDiagnostics<CR>', 'toggle quickfix diagnostics')

--- Display only the most severe diagnostic sign per line
local ns = vim.api.nvim_create_namespace('severe-diagnostics')
--- Get a reference to the original signs handler
local signs_handler = vim.diagnostic.handlers.signs

--- Override the built-in signs handler
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)
    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end
    -- Pass the filtered diagnostics (with our custom namespace) to
    -- the original handler
    signs_handler.show(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end,
  hide = function(_, bufnr)
    signs_handler.hide(ns, bufnr)
  end,
}

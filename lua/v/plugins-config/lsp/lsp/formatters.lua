
-- Handle formatting in a smarter way
-- If the buffer has been edited before formatting has completed, do not try to
-- apply the changes, by Lukas Reineke
vim.lsp.handlers['textDocument/formatting'] = function(err, result, ctx)
  if err ~= nil then
    vim.notify('error formatting', vim.lsp.log_levels.ERROR)
    return
  end

  if result == nil then
    -- vim.notify('no formatting changes', vim.lsp.log_levels.DEBUG)
    return
  end

  local bufnr = ctx.bufnr
  -- If the buffer hasn't been modified before the formatting has finished,
  -- update the buffer
  if not vim.api.nvim_buf_get_option(bufnr, 'modified') then
    local pos = vim.api.nvim_win_get_cursor(0)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    vim.lsp.util.apply_text_edits(
      result,
      bufnr,
      client and client.offset_encoding or 'utf-16'
    )
    pcall(vim.api.nvim_win_set_cursor, 0, pos)
    if bufnr == vim.api.nvim_get_current_buf() then
      vim.cmd 'noautocmd :update'
      -- vim.notify('formatting success', vim.lsp.log_levels.DEBUG)

      -- Trigger post-formatting autocommand which can be used to refresh gitsigns
      vim.api.nvim_do_autocmd(
        'User FormatterPost',
        { modeline = false }
      )
    end
  end
end

-- vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx)
--     if err ~= nil or result == nil then
--         return
--     end
--     if
--         vim.api.nvim_buf_get_var(ctx.bufnr, "init_changedtick") == vim.api.nvim_buf_get_var(ctx.bufnr, "changedtick")
--     then
--         local view = vim.fn.winsaveview()
--         vim.lsp.util.apply_text_edits(result, ctx.bufnr, "utf-16")
--         vim.fn.winrestview(view)
--         if ctx.bufnr == vim.api.nvim_get_current_buf() then
--             vim.b.saving_format = true
--             vim.cmd [[update]]
--             vim.b.saving_format = false
--         end
--     end
-- end

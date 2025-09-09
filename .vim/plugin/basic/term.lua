vim.api.nvim_create_augroup('luaterm', { clear = true })

local function err(msg, bufnr)
  vim.notify('buf' .. bufnr .. ': ' .. msg)
end

vim.api.nvim_create_autocmd({ 'TermRequest' }, {
  group = 'luaterm',
  desc = 'Handles OSC 7 dir change requests',
  callback = function(ev)
    if not ev.data.sequence or string.sub(ev.data.sequence, 1, 4) ~= '\x1b]7;' then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()

    local host, dir = ev.data.sequence:match('\x1b]7;file://([^/]*)(.*)')
    if host:len() > 0 and host ~= vim.loop.os_gethostname() then
      err('chdir on host: ' .. host .. ' (ignoring)')
      return
    end

    if vim.fn.isdirectory(dir) == 0 then
      err('invalid dir: ' .. dir)
      return
    end

    vim.api.nvim_buf_set_var(ev.buf, 'osc7_dir', dir)
    if ev.buf == bufnr then
      vim.cmd.lcd(dir)
    end
  end
})

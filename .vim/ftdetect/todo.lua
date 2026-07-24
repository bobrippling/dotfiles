local orig = require('vim.filetype.detect')["txt"]

require('vim.filetype.detect')["txt"] = function(path, bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 100, false)

  for _, line in ipairs(lines) do
    if line:match("^%[[%. x%-+]%]") then
      return "todo"
    end
  end

  return orig and orig(path, bufnr) or nil
end

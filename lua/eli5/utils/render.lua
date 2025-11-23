local M = {}

---@param content string
function M.render(content)
  vim.notify(content, vim.log.levels.DEBUG)
end

return M

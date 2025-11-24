local M = {}

---TODO decide on cursor pos or true middle (right now is just middle of current buffer)

---@param content string[]
function M.render(content)
  --- i should probably modularise this
  local buf_id = vim.api.nvim_create_buf(false, true)

  assert(buf_id, "Unable to generate buffer")

  local ok, err = pcall(vim.api.nvim_buf_set_lines, buf_id, 0, -1, true, content)
  assert(ok, err)

  local curr_h = vim.api.nvim_win_get_height(0)
  local curr_w = vim.api.nvim_win_get_width(0)
  local width = 100
  local height = 30

  local win_id = vim.api.nvim_open_win(buf_id, true, {
    relative = "win",
    row = curr_h / 2 - height / 2,
    col = curr_w / 2 - width / 2,
    width = width,
    height = height,
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  })

  --- can turn into a func that takes in options as a table
  vim.api.nvim_set_option_value("wrap", true, { win = win_id })
  vim.api.nvim_set_option_value("winhl", "FloatBorder:Normal", { win = win_id })

  assert(win_id, string.format("Unable to generate window on buffer: %d", buf_id))
end

return M

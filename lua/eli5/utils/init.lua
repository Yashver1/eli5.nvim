local M = {}

---@param file_path string
function M.load_api_key(file_path)
  local result = vim.fn.readfile(file_path)
  for _, line in ipairs(result) do
    for k, v in string.gmatch(line, "([^=]+)=(.+)") do
      if k == "OPENAPI_KEY" then
        return v
      end
    end
  end
  error("Unable to find env var OPENAPI_KEY")
end

---@param text string
---@param delim? string
---@return string[]
function M.split(text, delim)
  if delim == nil then
    delim = "\n"
  end
  local split_string = {}
  for line in string.gmatch(text, "([^" .. delim .. "]+)") do
    table.insert(split_string, line)
  end

  return split_string
end

function M.print_table(t, indent)
  indent = indent or 0
  local prefix = string.rep("  ", indent)

  if type(t) ~= "table" then
    print(prefix .. tostring(t))
    return
  end

  print(prefix .. "{")
  for k, v in pairs(t) do
    local key = tostring(k)
    if type(v) == "table" then
      print(prefix .. "  " .. key .. " = ")
      M.print_table(v, indent + 2)
    else
      print(prefix .. "  " .. key .. " = " .. tostring(v))
    end
  end
  print(prefix .. "}")
end

return M

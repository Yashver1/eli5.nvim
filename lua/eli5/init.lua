local api = require("eli5.utils.api")
local render_engine = require("eli5.utils.render")
local utils = require("eli5.utils")

---@class M
---@field config { api_key: string,model :string, endpoint: string}
---@field is_setup boolean

local M = {
  config = {
    api_key = "",
    endpoint = "",
    model = "",
    system_prompt = require("eli5.utils.system_prompt"),
  },
  is_setup = false,
}

---@param config { env_path: string, model: string, endpoint: string, prompt: string?}
function M.setup(config)
  local ok, result = pcall(utils.load_api_key, config.env_path)
  if not ok then
    vim.notify(result, vim.log.levels.ERROR)
  end

  M.config.api_key = result
  M.config.endpoint = config.endpoint
  M.config.model = config.model
  if config.prompt then
    M.config.system_prompt = config.prompt
  end
  M.is_setup = true
end

function M.eli5()
  local res = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))

  if not M.is_setup then
    vim.notify("eli5.nvim has not been provided with a config.", vim.log.levels.INFO)
  end

  local ok, err = pcall(api.call_api, {
    endpoint = M.config.endpoint,
    api_key = M.config.api_key,
    model = M.config.model,
    body = M.config.system_prompt .. table.concat(res, "\n"),
  }, render_engine)

  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

function M.__get_config()
  local fmt_string = ""
  for k, v in pairs(M.config) do
    fmt_string = fmt_string .. k .. " : " .. tostring(v) .. "\n"
  end

  vim.print(fmt_string, vim.log.levels.INFO)
end

return M

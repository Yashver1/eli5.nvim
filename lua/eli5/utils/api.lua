local json = require("eli5.utils.json")
local utils = require("eli5.utils")

local M = {}

---@param endpoint string
---@param api_key string
---@param model string
---@param body string
local function __craft_curl_req(endpoint, api_key, model, body)
  local json_body = json.stringify({
    model = model,
    messages = {
      { role = "user", content = body },
    },
  })

  local args = {
    "curl",
    "-sS",
    endpoint,
    "-X",
    "POST",
    "-H",
    "Content-Type: application/json",
    "-H",
    string.format("Authorization: Bearer %s", api_key),
    "-d",
    json_body,
  }

  return args
end

---TODO show loading result as notification on top (probably something like open notif and close notif on exit with a schedule first)

---@param payload { endpoint:string, api_key: string, model:string, body: string}
---@param renderer { render: function}
function M.call_api(payload, renderer)
  local args = __craft_curl_req(payload.endpoint, payload.api_key, payload.model, payload.body)

  local exit_handler = function(obj)
    local response = json.parse(obj.stdout)

    if response == nil or response == "" then
      vim.schedule(function()
        renderer.render({ "Empty result." })
      end)
    else
      vim.schedule(function()
        renderer.render(utils.split(response.choices[1].message.content))
      end)
    end

    if obj.stderr then
      vim.notify(obj.stderr, vim.log.levels.ERROR)
    end
  end

  vim.notify("explaining concept...", vim.log.levels.INFO)
  local ok, err = pcall(function()
    vim.system(args, { text = true }, exit_handler)
  end)

  assert(ok, "unable to send request: " .. tostring(err))
end

return M

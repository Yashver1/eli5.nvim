local json = require("eli5.utils.json")

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

---@param payload { endpoint:string, api_key: string, model:string, body: string}
---@param renderer { render: function}
function M.call_api(payload, renderer)
  local args = __craft_curl_req(payload.endpoint, payload.api_key, payload.model, payload.body)

  local exit_handler = function(obj)
    local response = json.parse(obj.stdout)
    if response == nil or response == "" then
      renderer.render("Empty result.")
    else
      renderer.render(response.choices[1].message.content)
    end

    if obj.stderr then
      renderer.render(obj.stderr)
    end
  end

  local ok, err = pcall(function()
    vim.system(args, { text = true }, exit_handler)
  end)

  if not ok then
    error("unable to send request: " .. tostring(err))
  end
end

return M

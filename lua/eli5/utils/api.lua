local json = require("eli5.utils.json")
local render_engine = require("eli5.utils.render")

local M = {}

---@param endpoint string
---@param api_key string
---@param model string
---@param body string
local function __craft_curl_req(endpoint, api_key, model, body)
	local args = {
		"curl",
		"-X",
		"POST",
		"-H",
		"Content-Type: application/json",
		"-H",
		("Authorization: Bearer %s"):format(api_key),
		"-d",
		string.format([[{"model": "%s", "messages": [{"role": "user", "content": "%s"}]}]], model, body),
		endpoint,
	}
	return args
end

---@param text string
local function parse_api_result(text) end

---@param payload { endpoint:string, api_key: string, model:string, body: string}
---@param renderer { render: function}
function M.call_api(payload, renderer)
	local args = __craft_curl_req(payload.endpoint, payload.api_key, payload.model, payload.body)

	local exit_handler = function(obj)
		renderer.render(obj.stdout)
		renderer.render(obj.stderr)
	end

	local ok, obj = pcall(vim.system, args, { text = true }, exit_handler)
	if not ok then
		error("unable to send request")
	end
	return nil
end

return M

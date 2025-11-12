local api = require("eli5.utils.api")
local render_engine = require("eli5.utils.render")

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

---@param config { api_key: string, model: string, endpoint: string, prompt: string?}
function M.setup(config)
	M.config.api_key = config.api_key
	M.config.endpoint = config.endpoint
	M.config.model = config.model
	if config.prompt then
		M.config.system_prompt = config.prompt
	end
	M.is_setup = true
end

function M.eli5()
	if not M.is_setup then
		vim.notify("eli5.nvim has not been configured with opts. Please do before using", vim.log.levels.INFO)
	end

	local ok, err = pcall(api.call_api, {
		endpoint = M.config.endpoint,
		api_key = M.config.api_key,
		model = M.config.model,
		body = M.config.system_prompt .. "This is a test",
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

	vim.notify(fmt_string, vim.log.levels.INFO)
end

return M

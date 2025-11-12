local M = {
	message = "",
}

function M.setup(config)
	M.message = config.message
end

function M.call()
	vim.print(M.message)
end

return M

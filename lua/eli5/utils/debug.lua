local M = {}

function M.print_table(table)
	local fmt_string = ""
	for k, v in pairs(table) do
		fmt_string = fmt_string .. k .. " : " .. tostring(v) .. "\n"
	end

	vim.print(fmt_string)
end

return M

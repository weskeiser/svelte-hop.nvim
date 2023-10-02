local Path = require("plenary.path")

local M = {}

function M.file_exists(fname)
	if fname == nil then
		return false
	end

	local f = io.open(fname, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

local function merge_table_impl(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k]) == "table" then
				merge_table_impl(t1[k], v)
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
end

function M.merge_tables(...)
	local out = {}
	for i = 1, select("#", ...) do
		merge_table_impl(out, select(i, ...))
	end
	return out
end

function M.expand_dir(config)
	local dirs = config.dirs or {}
	for k in pairs(dirs) do
		local expanded_path = Path.new(k):expand()
		dirs[expanded_path] = dirs[k]
		if expanded_path ~= k then
			dirs[k] = nil
		end
	end

	return config
end

return M

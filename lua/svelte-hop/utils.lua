local map = vim.keymap.set
local config = require("svelte-hop.config")

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

function M.is_sveltelike_dir()
	return vim.fn.expand("%"):find(config.activation_pattern) ~= nil
end

function M.open_sibling_by_filename(fname)
	local curr_path = vim.fn.expand("%")
	local fpath = vim.fn.fnamemodify(curr_path, ":p:h") .. "/" .. fname
	if fpath == curr_path then
		return
	else
		if M.file_exists(fpath) or config.create_if_missing then
			vim.cmd("e " .. fpath)
		else
			vim.notify(fname .. " does not exist for current route")
		end
	end
end

-- (arg): {config} or "unmap"
function M.map_svop_keys(arg)
	for filename, keymap in pairs(arg.keymaps) do
		map("n", keymap, function()
			M.open_sibling_by_filename(filename)
		end)
	end
end

return M

local map = vim.keymap.set

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
	return vim.fn.expand("%"):find(require("svelte-hop.config").activation_pattern) ~= nil
end

function M.open_sibling_by_filename(fname)
	local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h") .. "/" .. fname
	if M.file_exists(fpath) then
		vim.cmd("e " .. fpath)
	else
		vim.notify(fname .. " does not exist for current route")
	end
end

-- arg: {config} or "unmap"
function M.map_svop_keys(arg)
	for filename, keymap in pairs(arg.keymaps) do
		map("n", keymap, function()
			M.open_sibling_by_filename(filename)
		end)
	end
end

return M

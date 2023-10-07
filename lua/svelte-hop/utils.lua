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
function M.filename_handle_hop(fname)
	local curr_path = vim.fn.expand("%")
	local fpath = vim.fn.fnamemodify(curr_path, ":p:h") .. "/" .. fname

	if fpath == curr_path then
		return
	else
		if M.file_exists(fpath) then
			vim.cmd("e " .. fpath)
		else
			if config.create_if_missing then
				local opts = {
					prompt = "Edit new route file " .. fname .. "? [y / n]: ",
				}

				local function thecb(input)
					if input == "y" or input == "yy" or input == "Y" or input == "yes" then
						vim.cmd("e " .. fpath)
					end
				end

				vim.ui.input(opts, thecb)
			else
				vim.notify(fname .. " does not exist for current route")
			end
		end
	end
end

-- (arg): {config} or "unmap"
function M.config_set_keymap(arg)
	for filename, keymap in pairs(arg.keymaps) do
		map("n", keymap, function()
			M.filename_handle_hop(filename)
		end)
	end
end

return M

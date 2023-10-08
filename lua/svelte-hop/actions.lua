local config = require("svelte-hop.config")
local utils = require("svelte-hop.utils")

local M = {}

function M.create_svop_activate_autocommand()
	vim.api.nvim_create_autocmd("BufAdd", {
		pattern = config.activation_pattern,
		callback = M.enable_and_activate_svop,
		once = true,
		group = vim.api.nvim_create_augroup("Svop", { clear = true }),
	})
end

function M.enable_and_activate_svop()
	config.update({ enabled = true, active = true })

	M.config_set_keymap(config)

	if config.status_icons then
		require("svelte-hop.highlights").setup()
		require("svelte-hop.status-icons").enable_status_icons()
	end
end

function M.enable_svop()
	if utils.is_sveltelike_dir() then
		M.enable_and_activate_svop()
	else
		config.update({ enabled = true })
		M.create_svop_activate_autocommand()
	end
end

function M.filename_handle_hop(fname)
	local curr_path = vim.fn.expand("%")
	local destination = vim.fn.fnamemodify(curr_path, ":p:h") .. "/" .. fname

	if destination == curr_path then
		return
	end

	if utils.file_exists(destination) then
		vim.cmd("e " .. destination)
		return
	end

	if config.create_if_missing then
		local opts = {
			prompt = string.format("Edit new route file %s? [y / n]: ", fname),
		}

		local function on_input(input)
			if input == "y" or input == "yy" or input == "Y" or input == "yes" then
				if config.templates.enabled == true then
					require("svelte-hop.templates").destination_template_create_rfile(destination, fname)
				else
					vim.cmd(string.format("e %s", destination))
				end
			else
				vim.notify("Route file creation cancelled")
			end
		end

		vim.ui.input(opts, on_input)
		return
	end

	vim.notify(string.format("%s does not exist for current route", fname))
end

function M.config_set_keymap(cfg)
	for filename, keymap in pairs(cfg.keymaps) do
		vim.keymap.set("n", keymap, function()
			M.filename_handle_hop(filename)
		end)
	end
end

return M

local M = {}
local utils = require("svelte-hop.utils")
local config = require("svelte-hop.config")
local usercmd = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

local command_args_filename_mappings = {
	["ps"] = "+page.svelte",
	["p"] = "+page.ts",
	["psv"] = "+page.server.ts",

	["ls"] = "+layout.svelte",
	["l"] = "+layout.ts",
	["lsv"] = "+layout.server.ts",

	["s"] = "+server.ts",
	["e"] = "+error.ts",
}

local function create_svop_activate_autocommand()
	vim.api.nvim_create_autocmd("BufAdd", {
		pattern = config.pattern,
		callback = function()
			print("BufAdd autocmd ran")
			M.enable_and_activate_svop()
		end,
		once = true,
		group = vim.api.nvim_create_augroup("Svop", { clear = true }),
	})
end

function M.enable_and_activate_svop()
	print("enable_and_activate_svop ran")
	config.update({ enabled = true, active = true })
	utils.map_svop_keys(config)
end

function M.enable_svop()
	if utils.is_sveltelike_dir() then
		print("enable_svop ran and is sveltelike dir")
		M.enable_and_activate_svop()
	else
		print("enable_svop ran and is not sveltelike dir")
		config.update({ enabled = true })
		create_svop_activate_autocommand()
	end
end

function M.setup(user_config)
	if not user_config then
		user_config = {}
	end

	config.update(user_config)

	if config.enabled and utils.is_sveltelike_dir() then
		print("setup ran, svop is enabled and is_sveltelike_dir")
		M.enable_and_activate_svop()
	else
		if config.enabled then
			print("setup ran, and svop is enabled")
			create_svop_activate_autocommand()
		end
	end

	usercmd("Svop", function(opts)
		local command_arg = opts.fargs[1]
		utils.open_sibling_by_filename(command_args_filename_mappings[command_arg])
	end, {
		nargs = 1,
		desc = "Svelte-Hop Navigator",
	})

	usercmd("SvopEnable", function()
		M.enable_svop()
	end, {})

	usercmd("SvopActivate", function()
		M.enable_and_activate_svop()
	end, {})
end

return M

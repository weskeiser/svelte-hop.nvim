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
			M.enable_and_activate_svop()
		end,
		once = true,
		group = vim.api.nvim_create_augroup("Svop", { clear = true }),
	})
end

function M.enable_and_activate_svop()
	config.update({ enabled = true, active = true })
	utils.map_svop_keys(config)
end

function M.enable_svop()
	if utils.is_sveltelike_dir() then
		M.enable_and_activate_svop()
	else
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
		M.enable_and_activate_svop()
	else
		if config.enabled then
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

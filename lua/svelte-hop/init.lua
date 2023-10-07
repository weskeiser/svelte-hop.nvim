local utils = require("svelte-hop.utils")
local config = require("svelte-hop.config")
local usercmd = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

local M = {}

M.route_files = {
	"+page.svelte",
	"+page.ts",
	"+page.server.ts",

	"+layout.svelte",
	"+layout.ts",
	"+layout.server.ts",

	"+server.ts",
	"+error.ts",
}

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

function SvopStatusline()
	if not config.status_icons then
		return ""
	end

	if not vim.b.svopstatus then
		return ""
	else
		return vim.b.svopstatus
	end
end

local function create_svop_activate_autocommand()
	autocmd("BufAdd", {
		pattern = config.activation_pattern,
		callback = M.enable_and_activate_svop,
		once = true,
		group = vim.api.nvim_create_augroup("Svop", { clear = true }),
	})
end

function M.enable_and_activate_svop()
	config.update({ enabled = true, active = true })

	utils.config_set_keymap(config)

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
		create_svop_activate_autocommand()
	end
end

-- Setup

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
		local cmd_arg = opts.fargs[1]
		utils.filename_handle_hop(cmd_args_filename_mappings[cmd_arg])
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

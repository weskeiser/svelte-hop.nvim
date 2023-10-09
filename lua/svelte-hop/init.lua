local utils = require("svelte-hop.utils")
local config = require("svelte-hop.config")
local actions = require("svelte-hop.actions")

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

local cmd_args_filename_mappings = {
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

-- Setup

function M.setup(user_config)
	if not user_config then
		user_config = {}
	end

	config.update(user_config)

	if config.enabled then
		actions.enable_svop()
	end

	vim.api.nvim_create_user_command("Svop", function(opts)
		local cmd_arg = opts.fargs[1]
		utils.filename_hop(cmd_args_filename_mappings[cmd_arg])
	end, {
		nargs = 1,
		desc = "Svelte-Hop Navigator",
	})

	vim.api.nvim_create_user_command("SvopEnable", function()
		actions.enable_svop()
	end, {})

	vim.api.nvim_create_user_command("SvopActivate", function()
		actions.activate_svop()
	end, {})
end

return M

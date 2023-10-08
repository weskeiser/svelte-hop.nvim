local config = require("svelte-hop.config")
local debug_utils = require("plenary.debug_utils")

local M = {}

function M.template_get_initial_pos(name)
	local config_template_value = config.templates.templates[name]
	if type(config_template_value) == "table" then
		return config_template_value
	else
		return { 1, 1 }
	end
end

function M.destination_template_create_rfile(destination, template)
	local template_dir

	if config.templates.template_dir ~= nil then
		template_dir = config.templates.template_dir
	else
		local svop_dir = vim.fn.fnamemodify(debug_utils.sourced_filepath(), ":h:h:h")
		template_dir = string.format("%s/templates", svop_dir)
	end

	local template_file = string.format("%s/%s", template_dir, template)
	local template_contents = require("svelte-hop.utils").file_get_contents(template_file)
	require("svelte-hop.utils").file_append_content(destination, template_contents)

	vim.cmd(string.format("e %s", destination))

	vim.api.nvim_win_set_cursor(0, M.template_get_initial_pos(template))
end

return M

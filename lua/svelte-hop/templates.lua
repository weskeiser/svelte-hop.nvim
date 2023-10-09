local config = require("svelte-hop.config")
local debug_utils = require("plenary.debug_utils")
local utils = require("svelte-hop.utils")

local M = {}

function M.template_get_initial_pos(template)
    local config_template_value = config.templates.templates[template]
    if type(config_template_value) == "table" then
        return config_template_value
    else
        return { 1, 1 }
    end
end

function M.get_template_dir()
    local template_dir = config.templates.template_dir

    if template_dir == nil then
        local svop_dir = vim.fn.fnamemodify(debug_utils.sourced_filepath(), ":h:h:h")
        template_dir = string.format("%s/templates", svop_dir)
    end

    return template_dir
end

-- function M.destination_template_create_routefile(destination, template)
function M.template_file_edit(template, file)
    local template_file = string.format("%s/%s", M.get_template_dir(), template)
    local template_contents = utils.file_get_contents(template_file)

    utils.file_append_content(file, template_contents)

    vim.cmd.edit(file)

    vim.api.nvim_win_set_cursor(0, M.template_get_initial_pos(template))
end

return M

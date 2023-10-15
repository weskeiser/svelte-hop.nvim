local utils = require("svelte-hop.utils")

local M = {}

function M.create_from_template_and_edit(template_name, file)
    local templates = require("svelte-hop.config").routefiles.templates
    local templates_dir = templates.dir
        or string.format(
            "%s/templates",
            vim.fn.fnamemodify(require("plenary.debug_utils").sourced_filepath(), ":h:h:h")
        )

    local contents = utils.file_get_contents(string.format("%s/%s", templates_dir, template_name))
    utils.file_append_content(file, contents)

    vim.cmd.edit(file)

    local config_pos = templates.templates[template_name]
    local pos = type(config_pos) == "table" and config_pos or { 1, 1 }
    vim.api.nvim_win_set_cursor(0, pos)
end

return M

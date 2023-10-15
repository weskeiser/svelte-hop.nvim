local config = require("svelte-hop.config")
local utils = require("svelte-hop.utils")

local M = {}

local routefiles_groups = {

    { "+page.svelte", 1 },
    { "+page.ts", 2 },
    { "+page.server.ts", 3 },

    { "+layout.svelte", 1 },
    { "+layout.ts", 2 },
    { "+layout.server.ts", 3 },

    { "+server.ts", 4 },
    { "+error.ts", 4 },
}

local function name_get_buf_svopstatus(bufname)
    local icons = config.statusline.icons

    local svopstatus_builder = { "%#SvopSep#", icons.start }

    for _, routefile_and_group in ipairs(routefiles_groups) do
        local routefile, group = unpack(routefile_and_group)

        local routefile_path = string.format("%s/%s", vim.fn.fnamemodify(bufname, ":p:h"), routefile)

        table.insert(svopstatus_builder, "%#Svop")
        table.insert(svopstatus_builder, group)

        -- If creating file and file is file being created
        if vim.g.svop_creating_file == routefile_path then
            table.insert(svopstatus_builder, "Creation#")
            table.insert(svopstatus_builder, icons.file_none)

        -- If not existing
        elseif not utils.file_exists(routefile_path) then
            table.insert(svopstatus_builder, "None#")
            table.insert(svopstatus_builder, icons.file_none)

        -- If current
        elseif bufname == routefile_path then
            table.insert(svopstatus_builder, "Current#")
            table.insert(svopstatus_builder, icons.file)

        -- If existing
        else
            table.insert(svopstatus_builder, "#")
            table.insert(svopstatus_builder, icons.file)
        end

        -- If group has separator after
        if group == 3 then
            table.insert(svopstatus_builder, "%#SvopSep#")
            table.insert(svopstatus_builder, icons.separator)
        end
    end

    table.insert(svopstatus_builder, icons.ending)
    table.insert(svopstatus_builder, "%#StatusLine#")

    return table.concat(svopstatus_builder)
end

function M.buf_set_svopstatus(buf)
    local bufname = vim.api.nvim_buf_get_name(buf)

    if not utils.in_routes_dir(bufname) then
        return
    end

    vim.b[buf].svopstatus = name_get_buf_svopstatus(bufname)
end

function M.refresh()
    if not config.statusline.enabled then
        return
    end

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)

        vim.api.nvim_win_set_hl_ns(win, require("svelte-hop.highlights").namespace)

        M.buf_set_svopstatus(buf)
    end

    vim.cmd("redrawstatus!")
end

function M.disable()
    config.update({ statusline = { enabled = false } })

    vim.api.nvim_clear_autocmds({ group = "SvopStatus" })

    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        vim.b[vim.api.nvim_win_get_buf(win)].svopstatus = nil
    end
end

return M

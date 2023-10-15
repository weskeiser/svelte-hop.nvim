local config = require("svelte-hop.config")
local utils = require("svelte-hop.utils")

local M = {}

local in_routes_dir_pattern = string.format("*/%s/*", config.routefiles.dir)

local function buf_svop(buf)
    local bufname = vim.api.nvim_buf_get_name(buf)

    if not utils.in_routes_dir(bufname) then
        return
    end

    vim.b[buf].svop = true

    require("svelte-hop.keymaps").buf_set(buf)
    require("svelte-hop.statusline").refresh()
end

M.create_event = {
    bufenter_svop = function()
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = in_routes_dir_pattern,
            callback = function(event)
                buf_svop(event.buf)
            end,
            group = vim.api.nvim_create_augroup("Svop", { clear = true }),
        })
    end,

    bufadd_activate_svop = function()
        vim.api.nvim_create_autocmd("BufAdd", {
            pattern = in_routes_dir_pattern,
            callback = M.activate,
            group = vim.api.nvim_create_augroup("SvopActivate", { clear = true }),
        })
    end,
}

function M.activate()
    local current_path = vim.fn.getcwd(0)

    if not config.enabled or not utils.in_svelte_dir(current_path) then
        return
    end

    config.update({ active = true })

    if config.statusline.enabled then
        vim.api.nvim_create_autocmd({ "WinNew" }, {
            pattern = in_routes_dir_pattern,
            callback = require("svelte-hop.statusline").refresh,
            group = vim.api.nvim_create_augroup("SvopStatus", { clear = true }),
        })
    end

    if utils.in_routes_dir(current_path) then
        buf_svop(0)
    end

    M.create_event.bufenter_svop()

    return true
end

function M.enable()
    config.update({ enabled = true })

    if utils.in_routes_dir(vim.api.nvim_buf_get_name(0)) then
        M.activate()
    else
        M.create_event.bufadd_activate_svop()
    end

    vim.api.nvim_exec_autocmds("User", { pattern = "SvopEnabled" })
end

function M.disable()
    config.update({ enabled = false, active = false })

    vim.api.nvim_clear_autocmds({ group = "Svop" })
    vim.api.nvim_clear_autocmds({ group = "SvopActivate" })
    require("svelte-hop.keymaps").disable()
    require("svelte-hop.statusline").disable()
end

function M.hop(filename)
    local curr_file = vim.api.nvim_buf_get_name(0)
    local hop_file = string.format("%s/%s", vim.fn.fnamemodify(curr_file, ":p:h"), filename)

    if hop_file == curr_file then
        return
    end

    if utils.file_exists(hop_file) then
        vim.cmd.edit(hop_file)
        return
    end

    if not config.routefiles.create_if_missing then
        vim.notify(string.format("[ Route file %s does not exist for current route ]", filename))
        return
    end

    vim.g.svop_creating_file = hop_file

    if config.statusline.enabled then
        require("svelte-hop.statusline").refresh()
    end

    local input_opts = {
        prompt = string.format("Edit new route file %s? [y / n]: ", filename),
    }

    vim.ui.input(input_opts, function(input)
        if input ~= "y" and input ~= "yy" and input ~= "Y" and input ~= "yes" then
            return vim.notify("[ Route file creation cancelled ]")
        elseif config.routefiles.templates.enabled then
            require("svelte-hop.templates").create_from_template_and_edit(filename, hop_file)
            return vim.notify(string.format("%s created", filename))
        else
            vim.cmd(string.format("e %s", hop_file))
            vim.notify(string.format("Editing %s", filename))
        end
    end)

    vim.g.svop_creating_file = nil

    if config.statusline.enabled then
        require("svelte-hop.statusline").refresh()
    end
end

return M

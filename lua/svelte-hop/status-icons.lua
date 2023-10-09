local config = require("svelte-hop.config")
local utils = require("svelte-hop.utils")

local M = {}

local route_files = {
    "+page.svelte",
    "+page.ts",
    "+page.server.ts",

    "+layout.svelte",
    "+layout.ts",
    "+layout.server.ts",

    "+server.ts",
    "+error.ts",
}

local route_files_hl_begin_and_end = {
    ["+page.svelte"] = { "%#Svop1", "%#SvopNC# " },
    ["+page.ts"] = { "%#Svop2", "%#SvopNC# " },
    ["+page.server.ts"] = { "%#Svop3", "%#SvopDivider#  " },

    ["+layout.svelte"] = { "%#Svop1", "%#SvopNC# " },
    ["+layout.ts"] = { "%#Svop2", "%#SvopNC# " },
    ["+layout.server.ts"] = { "%#Svop3", "%#SvopDivider#  " },

    ["+server.ts"] = { "%#Svop4", "%#SvopNC# " },
    ["+error.ts"] = { "%#Svop4", "" },
}

M.activation_pattern_bufenter_bufdelete_event = nil

function M.set_buf_svopstatus(buf)
    local current_path = vim.fn.expand("%")
    local curr_dir = vim.fn.fnamemodify(current_path, ":p:h")
    local icon = config.status_icons.icon or "◉"

    local statusline = {
        "%#SvopDivider#·⦗ ",
    }

    for _, filename in ipairs(route_files) do
        local hl_begin_and_end = route_files_hl_begin_and_end[filename]
        local hl_mod = ""

        if vim.fn.fnamemodify(current_path, ":t") == filename then
            hl_mod = "Current"
        else
            if not utils.file_exists(string.format("%s/%s", curr_dir, filename)) then
                hl_mod = "NC"
            end
        end

        table.insert(statusline, string.format("%s%s#%s%s", hl_begin_and_end[1], hl_mod, icon, hl_begin_and_end[2]))
    end

    table.insert(statusline, "%#SvopDivider# ⦘·%#StatusLine#")

    vim.b[buf].svopstatus = table.concat(statusline)
end

function M.enable_status_icons()
    config.update({ status_icons = { enabled = true } })

    M.activation_pattern_bufenter_bufdelete_event = vim.api.nvim_create_autocmd({ "BufEnter", "BufDelete" }, {
        pattern = config.activation_pattern,
        callback = function(event)
            M.set_buf_svopstatus(event.buf)
        end,
        group = vim.api.nvim_create_augroup("SvopStatus", { clear = true }),
    })

    M.set_buf_svopstatus(vim.api.nvim_get_current_buf())
end

function M.disable_status_icons()
    config.update({ status_icons = { enabled = false } })

    if M.activation_pattern_bufenter_bufdelete_event ~= nil then
        vim.api.nvim_del_autocmd(M.activation_pattern_bufenter_bufdelete_event)
        M.activation_pattern_bufenter_bufdelete_event = nil
    end
end

return M

local config = require("svelte-hop.config")

local M = {}

M.status_autocmd_id = nil

function M.set_buf_svopstatus(buf)
    local current_path = vim.fn.expand("%")
    local file_root = vim.fn.fnamemodify(current_path, ":p:h") .. "/"

    local statusline = "%#SvopDivider#·⦗ "

    for index, fname in ipairs(require("svelte-hop").route_files) do
        local group_no = 4
        local divider = ""

        if index == 1 or index == 4 then
            group_no = 1
            divider = "%#SvopNC# "
        else
            if index == 3 or index == 6 then
                group_no = 2
                divider = "%#SvopDivider#  "
            else
                if index == 2 or index == 5 then
                    group_no = 3
                    divider = "%#SvopNC# "
                else
                    if index == 7 or index == 8 then
                        group_no = 4

                        if index == 7 then
                            divider = "%#SvopNC# "
                        end
                    end
                end
            end
        end

        if vim.fn.fnamemodify(current_path, ":t") == fname then
            -- if is current file
            local hl = "%#Svop" .. group_no .. "Current#"

            statusline = statusline .. hl .. "◉" .. divider
        else
            -- if file exists
            if require("svelte-hop.utils").file_exists(file_root .. fname) then
                local hl = "%#Svop" .. group_no .. "#"

                statusline = statusline .. hl .. "◉" .. divider
            else
                -- if file does not exists
                local hl = "%#SvopNC#"

                statusline = statusline .. hl .. "◉" .. divider
            end
        end
    end

    vim.b[buf].svopstatus = statusline .. "%#SvopDivider# ⦘·%#StatusLine#"
end

function M.enable_status_icons()
    config.update({ status_icons = true })

    M.status_autocmd_id = vim.api.nvim_create_autocmd({ "BufEnter", "BufDelete" }, {
        pattern = config.activation_pattern,
        callback = function(event)
            M.set_buf_svopstatus(event.buf)
        end,
        group = vim.api.nvim_create_augroup("SvopStatus", { clear = true }),
    })

    M.set_buf_svopstatus(vim.api.nvim_get_current_buf())
end

function M.disable_status_icons()
    config.update({ status_icons = false })

    if M.status_autocmd_id ~= nil then
        vim.api.nvim_del_autocmd(M.status_autocmd_id)
        M.status_autocmd_id = nil
    end
end

return M

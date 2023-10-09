local M = {}

function M.setup()
    local setStatusHl = function(k, v)
        local user_hl_statusline = vim.api.nvim_get_hl(0, { name = "StatusLine" })
        local user_hl_statusline_bg = "#" .. vim.fn.printf("%x", user_hl_statusline.bg)

        v.bg = v.bg or user_hl_statusline_bg
        v.sp = v.sp or "#555555"

        if v.underline == nil then
            v.underline = true
        end

        vim.api.nvim_set_hl(0, k, v)
    end

    local highlights = {
        Svop1 = { fg = "#b98282" },
        Svop2 = { fg = "#66ac46" },
        Svop3 = { fg = "#6696cc" },
        Svop4 = { fg = "#8381a2" },

        Svop1Current = { fg = "#b98282", sp = "#bbbbbb" },
        Svop2Current = { fg = "#96cc66", sp = "#bbbbbb" },
        Svop3Current = { fg = "#86b6ec", sp = "#bbbbbb" },
        Svop4Current = { fg = "#8381a2", sp = "#bbbbbb" },

        SvopNC = { fg = "#555555" },
        SvopDivider = { fg = "#555555", underline = false },
    }

    for name, highlight in pairs(highlights) do
        if next(vim.api.nvim_get_hl(0, { name = name })) == nil then
            setStatusHl(name, highlight)
        end
    end
end

return M

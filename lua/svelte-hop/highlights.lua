local default_highlights = {
    Svop1 = { fg = "#b98282" },
    Svop2 = { fg = "#6696cc" },
    Svop3 = { fg = "#66ac46" },
    Svop4 = { fg = "#8381a2" },

    Svop1Current = { fg = "#b98282", sp = "#aaaaaa" },
    Svop2Current = { fg = "#86b6ec", sp = "#aaaaaa" },
    Svop3Current = { fg = "#96cc66", sp = "#aaaaaa" },
    Svop4Current = { fg = "#8381a2", sp = "#aaaaaa" },

    SvopNC = { fg = "#555555" },
    Svop1NC = { fg = "#555555" },
    Svop2NC = { fg = "#555555" },
    Svop3NC = { fg = "#555555" },
    Svop4NC = { fg = "#555555" },
    SvopDivider = { fg = "#555555", underline = false },
}

local M = {}

M.set_statusline_hl = function(k, v)
    v.sp = v.sp or "#555555"

    if v.underline == nil then
        v.underline = true
    end

    vim.api.nvim_set_hl(0, k, v)
end

function M.setup()
    local user_hl_statusline_bg =
        string.format("#%s", vim.fn.printf("%x", vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg))

    for name, highlight in pairs(default_highlights) do
        if next(vim.api.nvim_get_hl(0, { name = name })) == nil then
            -- ^ If hl not set by user

            highlight.bg = user_hl_statusline_bg or highlight.bg

            M.set_statusline_hl(name, highlight)
        end
    end
end

return M

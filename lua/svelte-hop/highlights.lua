local M = {}

M.highlights_base = {
    Svop1 = { fg = "#b98282" },
    Svop2 = { fg = "#6696cc" },
    Svop3 = { fg = "#66ac46" },
    Svop4 = { fg = "#8381a2" },
}

M.highlights_other = {
    SvopSep = { fg = "#666666" },
}

M.namespace = vim.api.nvim_create_namespace("Svop")

local function set_hl(k, v)
    vim.api.nvim_set_hl(M.namespace, k, v)
end

local function color_divide_lightness(color, divisor)
    divisor = divisor or 2

    local r_g_b = {
        string.sub(color, 2, 3),
        string.sub(color, 4, 5),
        string.sub(color, 6, 7),
    }

    for i, c in ipairs(r_g_b) do
        r_g_b[i] = string.format("%2x", tonumber(c, 16) / divisor):gsub(" ", 0)
    end

    return string.format("#%s", table.concat(r_g_b))
end

local function name_get_user_defined_hl(name)
    local user_defined_hl = vim.api.nvim_get_hl(0, { name = name })
    return next(user_defined_hl) and user_defined_hl or nil
end

function M.setup()
    M.namespace = vim.api.nvim_create_namespace("Svop")

    local user_hl_statusline = name_get_user_defined_hl("StatusLine")

    local user_hl_bg_statusline = user_hl_statusline
        and user_hl_statusline.bg
        and string.format("#%s", vim.fn.printf("%x", user_hl_statusline.bg))

    -- Set highlights
    for name, hl in pairs(M.highlights_base) do
        hl.bg = user_hl_bg_statusline or hl.bg

        hl = name_get_user_defined_hl(name) or hl

        -- File exists
        set_hl(name, hl)

        -- File does not exist
        local none_hl = vim.deepcopy(hl)
        none_hl.fg = color_divide_lightness(hl.fg)
        set_hl(string.format("%sNone", name), none_hl)

        -- File is being created
        local creation_hl = vim.deepcopy(hl)
        creation_hl.bg = color_divide_lightness(hl.fg)
        set_hl(string.format("%sCreation", name), creation_hl)

        -- File is current file in respective buf
        local current_hl = vim.deepcopy(hl)
        current_hl.underline = true
        current_hl.sp = hl.fg
        set_hl(string.format("%sCurrent", name), current_hl)
    end

    for name, hl in pairs(M.highlights_other) do
        hl.bg = user_hl_bg_statusline or hl.bg

        hl = name_get_user_defined_hl(name) or hl

        set_hl(name, hl)
    end
end

return M

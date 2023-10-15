-- Based on https://github.com/nvim-treesitter/nvim-treesitter-context/blob/master/lua/treesitter-context/config.lua

local default_config = {
    enabled = true,
    active = false,

    routefiles = {
        dir = "src/routes",
        create_if_missing = true,
        templates = {
            enabled = true,
            dir = nil,
            templates = {
                ["+page.svelte"] = { 2, 3 },
                ["+page.ts"] = { 1, 20 },
                ["+page.server.ts"] = { 1, 27 },

                ["+layout.svelte"] = { 2, 3 },
                ["+layout.ts"] = { 1, 20 },
                ["+layout.server.ts"] = { 1, 27 },

                ["+server.ts"] = { 1, 17 },
                ["+error.ts"] = { 1, 1 },
            },
        },
    },

    statusline = {
        enabled = false,
        icons = {
            -- file = "╚╝",
            file = "└┘",
            file_none = "└┘",
            start = "",
            ending = "",
            separator = "  ",
        },
    },

    templates = {
        enabled = true,
        dir = string.format(
            "%s/templates",
            vim.fn.fnamemodify(require("plenary.debug_utils").sourced_filepath(), ":h:h:h")
        ),
        templates = {
            ["+page.svelte"] = { 2, 3 },
            ["+page.ts"] = { 1, 20 },
            ["+page.server.ts"] = { 1, 27 },

            ["+layout.svelte"] = { 2, 3 },
            ["+layout.ts"] = { 1, 20 },
            ["+layout.server.ts"] = { 1, 27 },

            ["+server.ts"] = { 1, 17 },
            ["+error.ts"] = { 1, 1 },
        },
    },
    keymaps = require("svelte-hop.keymaps").default_keymaps,
}

local config = vim.deepcopy(default_config)

local M = {}

function M.update(cfg)
    config = vim.tbl_deep_extend("force", config, cfg)
end

setmetatable(M, {
    __index = function(_, k)
        return config[k]
    end,
})

return M

local config = require("svelte-hop.config")
local svop = require("svelte-hop.svop")

local M = {}

function M.hop(filename)
    svop.hop(filename)
end

function M.enable()
    config.update({ enabled = true })
    svop.enable()
end

function M.disable()
    config.update({ enabled = false })
    svop.disable()
end

function M.setup(user_config)
    if user_config then
        config.update(user_config)
    end

    function _G.SvopStatus()
        return vim.b["svopstatus"] or ""
    end

    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function()
            require("svelte-hop.highlights").setup()
        end,
        once = true,
        group = vim.api.nvim_create_augroup("SvopSetup", { clear = true }),
    })

    if config.enabled then
        svop.enable()
    end

    vim.api.nvim_create_user_command("SvopEnable", svop.enable, {})
    vim.api.nvim_create_user_command("SvopActivate", svop.activate, {})
end

return M

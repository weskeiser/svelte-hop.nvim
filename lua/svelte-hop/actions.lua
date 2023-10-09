local config = require("svelte-hop.config")
local utils = require("svelte-hop.utils")

local M = {}

function M.create_svop_activate_autocommand()
    vim.api.nvim_create_autocmd("BufAdd", {
        pattern = config.activation_pattern,
        callback = M.activate_svop,
        once = true,
        group = vim.api.nvim_create_augroup("Svop", { clear = true }),
    })
end

function M.activate_svop()
    if not config.enabled then
        return vim.notify("Svelte-Hop must be enabled before it can be activated")
    end

    config.update({ active = true })

    M.config_set_keymap(config)

    if config.status_icons then
        require("svelte-hop.highlights").setup()
        require("svelte-hop.status-icons").enable_status_icons()
    end
end

function M.enable_svop()
    config.update({ enabled = true })

    if not utils.is_sveltelike_dir() then
        M.create_svop_activate_autocommand()
    else
        M.activate_svop()
    end
end

function M.filename_hop(filename)
    local curr_file = vim.fn.expand("%")
    local hop_file = string.format("%s/%s", vim.fn.fnamemodify(curr_file, ":p:h"), filename)

    if hop_file == curr_file then
        return
    end

    if utils.file_exists(hop_file) then
        return vim.cmd.edit(hop_file)
    end

    if config.create_if_missing then
        local function on_confirm(input)
            if input == "y" or input == "yy" or input == "Y" or input == "yes" then
                if config.templates.enabled == true then
                    require("svelte-hop.templates").template_file_edit(filename, hop_file)
                    vim.notify(string.format("%s created", filename))
                else
                    vim.cmd(string.format("e %s", hop_file))
                    vim.notify("")
                end
            else
                vim.notify("Route file creation cancelled")
            end
        end

        local opts = {
            prompt = string.format("Edit new route file %s? [y / n]: ", filename),
        }

        vim.ui.input(opts, on_confirm)
    end

    vim.notify(string.format("%s does not exist for current route", filename))
end

function M.config_set_keymap(cfg)
    for filename, keymap in pairs(cfg.keymaps) do
        vim.keymap.set("n", keymap, function()
            M.filename_hop(filename)
        end)
    end
end

return M

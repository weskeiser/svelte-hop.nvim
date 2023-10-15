local M = {}

M.default_keymaps = {
    ["+page.svelte"] = "<leader>1",
    ["+page.ts"] = "<leader>2",
    ["+page.server.ts"] = "<leader>3",

    ["+server.ts"] = "<leader>4",
    ["+error.ts"] = "<leader>5",

    ["+layout.svelte"] = "<leader>7",
    ["+layout.ts"] = "<leader>8",
    ["+layout.server.ts"] = "<leader>9",
}

function M.buf_set(buf)
    if vim.b.svopkeys then
        return
    end

    for filename, mapping in pairs(require("svelte-hop.config").keymaps) do
        vim.keymap.set("n", mapping, function()
            require("svelte-hop.svop").hop(filename)
        end, { buffer = buf })
    end

    vim.b.svopkeys = true
end

local function buf_del(buf)
    for _, mapping in pairs(require("svelte-hop.config").keymaps) do
        vim.keymap.del("n", mapping, { buffer = buf })
    end

    vim.b[buf].svopkeys = false
end

function M.disable()
    vim.api.nvim_clear_autocmds({ group = "SvopKeymaps" })

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        buf_del(buf)
    end
end

return M

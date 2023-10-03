local M = {}
local utils = require("svelte-hop.utils")

M.commands_short = {
	["ps"] = "+page.svelte",
	["p"] = "+page.ts",
	["psv"] = "+page.server.ts",

	["ls"] = "+layout.svelte",
	["l"] = "+layout.ts",
	["lsv"] = "+layout.server.ts",

	["s"] = "+server.ts",
	["e"] = "+error.ts",
}

function M.navigate_sibling_by_name(fname)
	local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h") .. "/" .. fname
	if utils.file_exists(fpath) then
		vim.cmd("e " .. fpath)
	end
end

function M.setup(config)
	if not config then
		config = {}
	end

	local merged_config = utils.merge_tables({
		keymaps = {
			["+page.svelte"] = "<leader>1",
			["+page.ts"] = "<leader>3",
			["+page.server.ts"] = "<leader>5",

			["+layout.svelte"] = "<leader>2",
			["+layout.ts"] = "<leader>4",
			["+layout.server.ts"] = "<leader>6",

			["+server.ts"] = "<leader>7",
			["+error.ts"] = "<leader>0",
		},
	}, utils.expand_dir(config))

	local map = vim.keymap.set

	for filename, keymap in pairs(merged_config.keymaps) do
		map("n", keymap, function()
			M.navigate_sibling_by_name(filename)
		end)
	end

	vim.api.nvim_create_user_command("Svop", function(opts)
		local fname = M.commands_short[opts.fargs[1]]
		M.navigate_sibling_by_name(fname)
	end, {
		nargs = 1,
		desc = "Svelte-Hop",
	})
end

return M

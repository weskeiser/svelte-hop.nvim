-- Based on https://github.com/nvim-treesitter/nvim-treesitter-context/blob/master/lua/treesitter-context/config.lua

local default_config = {
	enabled = true,
	active = false,
	activation_pattern = "*/src/routes/*",
	keymaps = {
		["+page.svelte"] = "<leader>2",
		["+page.ts"] = "<leader>3",
		["+page.server.ts"] = "<leader>4",

		["+layout.server.ts"] = "<leader>7",
		["+layout.ts"] = "<leader>8",
		["+layout.svelte"] = "<leader>9",

		["+server.ts"] = "<leader>6",
		["+error.ts"] = "<leader>5",
	},
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

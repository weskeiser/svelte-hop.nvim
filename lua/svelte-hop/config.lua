-- Based on https://github.com/nvim-treesitter/nvim-treesitter-context/blob/master/lua/treesitter-context/config.lua

local default_config = {
	enabled = true,
	active = false,
	activation_pattern = "*/src/routes/*",
	create_if_missing = false,
	status_icons = false,
	templates = {
		enabled = true,
		template_dir = nil,
		templates = {
			["+page.svelte"] = { 2, 3 },
			["+page.ts"] = { 1, 20 },
			["+page.server.ts"] = { 1, 27 },

			["+layout.svelte"] = { 2, 3 },
			["+layout.ts"] = { 1, 20 },
			["+layout.server.ts"] = { 1, 27 },

			["+server.ts"] = { 1, 17 },
			["+error.ts"] = { 1, 20 },
		},
	},
	keymaps = {
		["+page.svelte"] = "<leader>2",
		["+page.ts"] = "<leader>3",
		["+page.server.ts"] = "<leader>4",

		["+layout.svelte"] = "<leader>7",
		["+layout.ts"] = "<leader>8",
		["+layout.server.ts"] = "<leader>9",

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

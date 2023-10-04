local utils = require("svelte-hop.utils")
local config = require("svelte-hop.config")
local setHl = function(k, v)
	vim.api.nvim_set_hl(0, k, v)
end

setHl("SvopGroup1", { fg = "#77cc77" })
setHl("SvopGroup1Missing", { fg = "#777777" })
setHl("SvopGroup2", { fg = "#7777cc" })
setHl("SvopGroup2Missing", { fg = "#777777" })
setHl("SvopGroup3", { fg = "#cccccc" })
setHl("SvopGroup3Missing", { fg = "#777777" })

local fnames_icons = {
	["+page.svelte"] = " ❶ ",
	["+page.ts"] = " ❷ ",
	["+page.server.ts"] = " ❸  ",

	["+layout.svelte"] = " ❶ ",
	["+layout.ts"] = " ❷ ",
	["+layout.server.ts"] = " ❸  ",

	["+server.ts"] = " ❹ ",
	["+error.ts"] = " ❺",
}

local M = {}

M.status_autocmd_id = nil

function M.set_buflocal_statusline(buf)
	local froot = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h") .. "/"

	print(buf)
	local statusline = ""
	for i, fname in ipairs(require("svelte-hop").route_files) do
		local group_no = 1

		if i > 6 then
			group_no = 3
		else
			if i > 3 then
				group_no = 2
			end
		end

		local hl = "%#SvopGroup" .. group_no

		if utils.file_exists(froot .. fname) then
			hl = hl .. "#"
		else
			hl = hl .. "Missing#"
		end

		statusline = statusline .. hl .. fnames_icons[fname]
	end

	vim.b[buf].svopstatus = statusline
end

function M.enable_status_icons()
	config.update({ status_icons = true })

	M.status_autocmd_id = vim.api.nvim_create_autocmd({ "BufEnter", "BufDelete" }, {
		pattern = config.activation_pattern,
		callback = function(event)
			M.set_buflocal_statusline(event.buf)
		end,
		group = vim.api.nvim_create_augroup("SvopStatus", { clear = true }),
	})

	local buf = vim.api.nvim_get_current_buf()
	M.set_buflocal_statusline(buf)
end

function M.disable_status_icons()
	config.update({ status_icons = false })

	if M.status_autocmd_id ~= nil then
		vim.api.nvim_del_autocmd(M.status_autocmd_id)
		M.status_autocmd_id = nil
	end
end

return M

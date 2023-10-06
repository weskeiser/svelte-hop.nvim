local config = require("svelte-hop.config")
local setHl = function(k, v)
	vim.api.nvim_set_hl(0, k, v)
end

setHl("Svop1", { fg = "#b98282" })
setHl("Svop2", { fg = "#6696cc" })
setHl("Svop3", { fg = "#96cc66" })
setHl("Svop4", { fg = "#8381a2" })
setHl("CurrentSvop1", { fg = "#b98282", sp = "#cf9ad7", underline = true })
setHl("CurrentSvop2", { fg = "#86b6ec", sp = "#a6d6ff", underline = true })
setHl("CurrentSvop3", { fg = "#96cc66", sp = "#b6ec86", underline = true })
setHl("CurrentSvop4", { fg = "#8381a2", sp = "#a3a1c2", underline = true })
setHl("MissingSvop", { fg = "#555555" })

--
local M = {}

M.status_autocmd_id = nil

function M.set_buf_svopstatus(buf)
	local current_path = vim.fn.expand("%")
	local file_root = vim.fn.fnamemodify(current_path, ":p:h") .. "/"

	local statusline = ""

	local function append_icon_statusline(hl_name, groupnr, icon, space_after)
		if not groupnr then
			groupnr = ""
		end

		statusline = statusline .. "%#" .. hl_name .. groupnr .. "#" .. icon .. "%#Normal#" .. space_after
	end

	for i, fname in ipairs(require("svelte-hop").route_files) do
		local group_no = 4
		local space_after = " "

		if i == 1 or i == 4 then
			group_no = 1
		else
			if i == 3 or i == 6 then
				group_no = 2
				space_after = "  "
			else
				if i == 2 or i == 5 then
					group_no = 3
				end
			end
		end

		if vim.fn.fnamemodify(current_path, ":t") == fname then
			-- if is current file
			append_icon_statusline("CurrentSvop", group_no, "◉", space_after)
		else
			if require("svelte-hop.utils").file_exists(file_root .. fname) then
				-- if file exists
				append_icon_statusline("Svop", group_no, "●", space_after)
			else
				-- if file does not exists
				append_icon_statusline("MissingSvop", nil, "●", space_after)
			end
		end
	end

	vim.b[buf].svopstatus = statusline
end

function M.enable_status_icons()
	config.update({ status_icons = true })

	M.status_autocmd_id = vim.api.nvim_create_autocmd({ "BufEnter", "BufDelete" }, {
		pattern = config.activation_pattern,
		callback = function(event)
			M.set_buf_svopstatus(event.buf)
		end,
		group = vim.api.nvim_create_augroup("SvopStatus", { clear = true }),
	})

	local buf = vim.api.nvim_get_current_buf()
	M.set_buf_svopstatus(buf)
end

function M.disable_status_icons()
	config.update({ status_icons = false })

	if M.status_autocmd_id ~= nil then
		vim.api.nvim_del_autocmd(M.status_autocmd_id)
		M.status_autocmd_id = nil
	end
end

return M

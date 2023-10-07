local config = require("svelte-hop.config")

local user_hl_statusline = vim.api.nvim_get_hl(0, { name = "StatusLine" })
local user_hl_statusline_bg = "#" .. vim.fn.printf("%x", user_hl_statusline.bg)

local setStatusHl = function(k, v)
	v.bg = v.bg or user_hl_statusline_bg

	if v.underline == nil then
		v.underline = true
	end

	vim.api.nvim_set_hl(0, k, v)
end

setStatusHl("Svop1", { fg = "#b98282", sp = "#555555" })
setStatusHl("Svop2", { fg = "#66ac46", sp = "#555555" })
setStatusHl("Svop3", { fg = "#6696cc", sp = "#555555" })
setStatusHl("Svop4", { fg = "#8381a2", sp = "#555555" })
setStatusHl("Svop1Current", { fg = "#b98282", sp = "#bbbbbb" })
setStatusHl("Svop2Current", { fg = "#96cc66", sp = "#bbbbbb" })
setStatusHl("Svop3Current", { fg = "#86b6ec", sp = "#bbbbbb" })
setStatusHl("Svop4Current", { fg = "#8381a2", sp = "#bbbbbb" })

setStatusHl("SvopMissing", { fg = "#555555", sp = "#555555" })
setStatusHl("SvopDivider", { fg = "#555555", underline = false })
setStatusHl("SvopUnderline", { fg = "#555555" })

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

local M = {}

function M.file_exists(fname)
    if fname == nil then
        return false
    end

    local f = io.open(fname, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

function M.file_get_contents(file)
    local opened_file = assert(io.open(file, "r"))
    local contents = opened_file:read("a")
    opened_file:close()
    return contents
end

function M.file_append_content(file, content)
    local opened_file = assert(io.open(file, "a"))
    opened_file:write(content)
    opened_file:flush()
    opened_file:close()
end

function M.in_svelte_dir(path)
    return vim.fs.find("svelte.config.*", { path = path, upward = true, type = "directory" })
end

function M.in_routes_dir(path)
    return path:find(require("svelte-hop.config").routefiles.dir) ~= nil
end

return M

P = function(...)
    vim.print(...)
end

-- I know that these are deprecated, I just don't want the warning all the time
-- Do a very big hack until the plugins I use updates to newer API's
local deprecations = {
    "client.notify",
    "client.is_stopped",
    "vim.lsp.start_client()",
}

local deprecate = vim.deprecate
---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function(name, ...)
    if vim.list_contains(deprecations, name) then
        return nil
    end
    return deprecate(name, ...)
end

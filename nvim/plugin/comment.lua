local get_option = vim.filetype.get_option

local uncomment_calculation_config = {
    c = { "// %s", "/* %s */" },
    cs = { "// %s", "/* %s */" },
}

local function uncomment_calculation(language)
    local function uncomment_match(commentstring)
        local curr_line = vim.api.nvim_get_current_line():gsub("%s+", "")
        local str = vim.split(commentstring, "%s", { plain = true })

        local start = string.sub(curr_line, 0, #str[1]):gsub("%s+", "")
        local last = string.sub(curr_line, 0 - #str[2], -1):gsub("%s+", "")

        return str[1] == start and (str[2] == last or #str[2] == 0)
    end

    return vim.iter(uncomment_calculation_config[language] or {}):find(function(commentstring)
        return uncomment_match(commentstring)
    end)
end

---@diagnostic disable-next-line: duplicate-set-field
function vim.filetype.get_option(ft, option)
    if option ~= "commentstring" then
        return get_option(ft, option)
    end

    local commentstring = uncomment_calculation(ft)
    if commentstring then
        return commentstring
    end

    return get_option(ft, "commentstring")
end

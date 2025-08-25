local ok, _ = pcall(require, "nvim-autopairs")
if ok then
    return
end

local matches = {
    ["("] = ")",
    ["{"] = "}",
    ["["] = "]",
    ['"'] = '"',
    ["'"] = "'",
    ["`"] = "`",
}

local function feed(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

local function get_chars()
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local char_before = line:sub(col, col)
    local char_after = line:sub(col + 1, col + 1)
    return col ~= 0 and char_before or nil, col ~= #line and char_after or nil
end

local function between_brackets()
    local char_before, char_after = get_chars()
    return (char_before == "(" and char_after == ")")
        or (char_before == "[" and char_after == "]")
        or (char_before == "{" and char_after == "}")
end

local function between_quotes()
    local char_before, char_after = get_chars()
    return (char_before == "'" and char_after == "'")
        or (char_before == '"' and char_after == '"')
        or (char_before == "`" and char_after == "`")
end

local function try_insert_match(typed)
    local closing = matches[typed]
    local char_before, char_after = get_chars()

    if not char_after or between_brackets() then
        return feed(string.format("%s<Left>", closing))
    end

    if char_after == "]" or char_after == "}" or char_after == ")" then
        return feed(string.format("%s<Left>", closing))
    end

    if char_before and char_before:match("%s") and char_after:match("%s") then
        return feed(string.format("%s<Left>", closing))
    end
end

local function try_skip(typed)
    local _, char_after = get_chars()
    if char_after == typed then
        feed("<Right><BS>")
    end
end

local function try_insert_quote(typed)
    local char_before, char_after = get_chars()

    if char_before and char_before:match("%s") and char_after and char_after:match("%s") then
        return try_insert_match(typed)
    end

    if not char_before and not char_after then
        return try_insert_match(typed)
    end

    if not char_before and char_after and char_after:match("%s") then
        return try_insert_match(typed)
    end

    if char_before and char_before:match("%s") and not char_after then
        return try_insert_match(typed)
    end

    if char_before == "[" or char_before == "{" or char_before == "(" then
        return try_insert_match(typed)
    end

    return try_skip(typed)
end

vim.on_key(function(_, typed)
    if vim.fn.mode() ~= "i" then
        return
    end

    if vim.bo.buftype == "prompt" then
        return
    end

    if typed == "(" or typed == "{" or typed == "[" then
        try_insert_match(typed)
    elseif typed == ")" or typed == "}" or typed == "]" then
        try_skip(typed)
    elseif typed == '"' or typed == "'" or typed == "`" then
        try_insert_quote(typed)
    elseif vim.fn.keytrans(typed) == "<CR>" then
        if between_brackets() or between_quotes() then
            feed("<Esc>O")
        end
    elseif vim.fn.keytrans(typed) == "<BS>" then
        if between_brackets() or between_quotes() then
            feed("<Right><BS>")
        end
    end
end)

vim.g.colors_name = "colorscheme"

local function highlight(colors)
    for name, opts in pairs(colors) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end

---------- COLORS ----------

local c = {
    bg = "#1c1c1c",
    bg2 = "#3f424f",
    bg3 = "#121212",
    bg4 = "#2f2f2f",
    fg = "#eeeeee",
    diff_red = "#55393d",
    diff_green = "#394634",
    diff_red_bright = "#71394a",
    diff_green_bright = "#5d7255",
    diff_blue = "#2a3445",
    changed_text = "#3f4d67",
    border = "#80A0C2",
    red = "#fc5d7c",
    orange = "#fea24f",
    yellow = "#e7c664",
    green = "#9ed072",
    blue = "#76cce0",
    purple = "#b39df3",
    grey = "#7f8490",
}

highlight({
    ---------- HIGHLIGHTING GROUPS ----------

    Added = { fg = c.green },
    Removed = { fg = c.red },
    Changed = { fg = c.blue },

    ColorColumn = { bg = c.bg },
    Conceal = { fg = c.grey },
    Cursor = { reverse = true },
    CursorColumn = { bg = c.bg },
    CursorLine = { bg = c.bg2 },
    CursorLineNr = { fg = c.fg },
    DiffAdd = { bg = c.diff_green },
    DiffChange = { bg = c.diff_blue },
    DiffDelete = { bg = c.diff_red },
    DiffText = { bg = c.changed_text },
    Directory = { fg = c.blue },
    ErrorMsg = { fg = c.red },
    FloatBorder = { fg = c.bg4 },
    FoldColumn = { fg = c.grey },
    Folded = { fg = c.grey, bg = c.bg },
    CurSearch = { fg = c.bg, bg = c.red },
    IncSearch = { fg = c.bg, bg = c.red },
    LineNr = { fg = c.grey },
    MatchParen = { bg = c.bg2 },
    ModeMsg = { fg = c.fg, bold = true },
    MoreMsg = { fg = c.blue, bold = true },
    NonText = { fg = c.bg2 },
    Normal = { fg = c.fg, bg = c.bg },
    NormalFloat = { fg = c.fg, bg = c.bg4 },
    Pmenu = { fg = c.fg, bg = c.bg2 },
    PmenuSbar = { bg = c.bg2 },
    PmenuSel = { fg = c.bg, bg = c.green },
    PmenuThumb = { bg = c.grey },
    Question = { fg = c.yellow },
    QuickFixLine = { fg = c.blue, bold = true },
    Search = { fg = c.bg, bg = c.green },
    SignColumn = { fg = c.fg },
    SpecialKey = { fg = c.bg2 },
    SpellBad = { fg = c.red, undercurl = true, sp = c.red },
    SpellCap = { fg = c.yellow, undercurl = true, sp = c.yellow },
    SpellLocal = { fg = c.blue, undercurl = true, sp = c.blue },
    SpellRare = { fg = c.purple, undercurl = true, sp = c.purple },
    StatusLine = { fg = c.fg, bg = c.bg4 },
    StatusLineNC = { fg = c.grey, bg = c.bg4 },
    StatusLineTerm = { fg = c.fg, bg = c.bg2 },
    StatusLineTermNC = { fg = c.grey, bg = c.bg },
    TabLine = { fg = c.grey, bg = c.bg3 },
    WinBar = { fg = c.fg },
    WinBarNC = { fg = c.grey, bg = c.bg },
    TabLineFill = { fg = c.grey, bg = c.bg3 },
    TabLineSel = { fg = c.fg, bg = c.bg, italic = true, bold = true },
    VertSplit = { fg = c.grey },
    Visual = { bg = c.bg2 },
    VisualNOS = { bg = c.bg2, underline = true },
    WarningMsg = { fg = c.yellow, bold = true },
    Whitespace = { fg = c.bg2 },
    WildMenu = { link = "PmenuSel" },
    iCursor = { link = "Cursor" },
    lCursor = { link = "Cursor" },
    vCursor = { link = "Cursor" },

    ---------- SYNTAX GROUP NAMES ----------

    Boolean = { fg = c.purple },
    Character = { fg = c.yellow },
    Comment = { fg = c.grey, italic = true },
    Conditional = { fg = c.red },
    Constant = { fg = c.orange },
    Define = { fg = c.red },
    Delimiter = { fg = c.fg },
    Error = { fg = c.red },
    Exception = { fg = c.red },
    Float = { fg = c.purple },
    Function = { fg = c.green },
    Identifier = { fg = c.fg },
    Ignore = { fg = c.grey },
    Include = { fg = c.red },
    Keyword = { fg = c.red },
    Label = { fg = c.red },
    Macro = { fg = c.purple },
    Number = { fg = c.purple },
    Operator = { fg = c.red },
    PreCondit = { fg = c.red },
    PreProc = { fg = c.blue },
    Repeat = { fg = c.red },
    Special = { fg = c.purple },
    SpecialChar = { fg = c.purple },
    SpecialComment = { fg = c.grey, italic = true },
    Statement = { fg = c.red },
    StorageClass = { fg = c.blue },
    String = { fg = c.yellow },
    Structure = { fg = c.blue },
    Tag = { fg = c.blue },
    Title = { fg = c.red, bold = true },
    Todo = { fg = c.blue, italic = true },
    Type = { fg = c.blue },
    Typedef = { fg = c.red },
    Underlined = { underline = true },

    ---------- TREESITTER ----------

    -- My own for C custom structs
    ["@type.custom"] = { fg = c.purple },

    ["@attribute"] = { link = "PreProc", default = true },

    ["@constructor"] = { fg = c.fg },

    ["@constant.builtin"] = { fg = c.orange },
    ["@constant.macro"] = { link = "Define", default = true },

    ["@function.builtin"] = { link = "Function" },

    ["@keyword.storage"] = { link = "StorageClass", default = true },
    ["@keyword.debug"] = { link = "Debug", default = true },

    ["@keyword.directive"] = { link = "PreProc", default = true },

    ["@property"] = { fg = c.green },

    ["@punctuation.special"] = { fg = c.red },

    ["@string.escape"] = { link = "String" },
    ["@string.regexp"] = { link = "String", default = true },

    ["@tag.attribute"] = { fg = c.green },
    ["@tag.delimiter"] = { fg = c.red },

    ["@type.builtin"] = { link = "Type", default = true },
    ["@type.definition"] = { link = "Typedef", default = true },

    ["@markup"] = { link = "@none", default = true },
    ["@markup.environment"] = { link = "Macro", default = true },
    ["@markup.environment.name"] = { link = "Type", default = true },
    ["@markup.list"] = { fg = c.red },
    ["@markup.raw"] = { link = "String", default = true },

    ["@variable"] = { fg = c.fg },
    ["@variable.member"] = { fg = c.green },
    ["@variable.builtin"] = { fg = c.orange },

    -- Messes with injection of comment parser which is highlighting TODO, NOTE, WARNING, ERROR
    ["@lsp.type.comment.lua"] = { link = "@none" },

    ---------- NVIM LSPCONFIG ----------

    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.orange },
    DiagnosticInfo = { fg = c.yellow },
    DiagnosticHint = { fg = c.fg },
    DiagnosticUnderlineError = { undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.orange },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.yellow },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.fg },
    LspSignatureActiveParameter = { fg = c.red },
    LspReferenceText = { bg = c.bg2 },
    LspReferenceRead = { bg = c.bg2 },
    LspReferenceWrite = { bg = c.bg2 },

    ---------- GIT ----------

    GitSignsAddInline = { bg = c.diff_green_bright },
    GitSignsDeleteInline = { bg = c.diff_red_bright },
    GitSignsAddLn = { bg = c.diff_green },
    GitSignsDeleteLn = { bg = c.diff_red },

    ---------- STARTSCREEN ----------

    StartifyBracket = { fg = c.grey },
    StartifyFile = { fg = c.green },
    StartifyNumber = { fg = c.orange },
    StartifyPath = { fg = c.grey },
    StartifySlash = { fg = c.grey },
    StartifySection = { fg = c.blue },
    StartifyHeader = { fg = c.red },
    StartifySpecial = { fg = c.grey },

    ---------- CMP ----------

    CmpCompletionWindow = { bg = c.bg },
    CmpItemAbbrMatch = { fg = c.purple },
    CmpItemKind = { fg = c.blue },
    CmpItemKindClass = { link = "@type" },
    CmpItemKindColor = { fg = c.yellow },
    CmpItemKindConstant = { link = "@constant" },
    CmpItemKindConstructor = { link = "@constructor" },
    CmpItemKindEnum = { fg = c.blue },
    CmpItemKindEnumMember = { fg = c.purple },
    CmpItemKindEvent = { fg = c.red },
    CmpItemKindField = { link = "@variable.member" },
    CmpItemKindFile = { fg = c.yellow },
    CmpItemKindFolder = { link = "Directory" },
    CmpItemKindFunction = { link = "@function" },
    CmpItemKindInterface = { fg = c.blue },
    CmpItemKindKeyword = { link = "@keyword" },
    CmpItemKindMethod = { link = "@function.method" },
    CmpItemKindModule = { link = "@module" },
    CmpItemKindOperator = { link = "@operator" },
    CmpItemKindProperty = { link = "@property" },
    CmpItemKindReference = { fg = c.yellow },
    CmpItemKindSnippet = { fg = c.yellow },
    CmpItemKindStruct = { link = "@type" },
    CmpItemKindText = { fg = c.fg },
    CmpItemKindTypeParameter = { link = "@type" },
    CmpItemKindUnit = { fg = c.purple },
    CmpItemKindValue = { fg = c.purple },
    CmpItemKindVariable = { link = "@variable" },
})

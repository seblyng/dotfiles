local highlight = function(colors)
    for name, opts in pairs(colors) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end

---------- COLORS ----------

local c = {
    red = '#E06C75',
    dark_red = '#BE5046',
    green = '#98C379',
    yellow = '#E5C07B',
    dark_yellow = '#D19A66',
    orange = '#fea24f',
    blue = '#61AFEF',
    purple = '#C678DD',
    cyan = '#56B6C2',
    white = '#ABB2BF',
    black = '#282C34',
    fg = '#ABB2BF',
    bg = '#1c1c1c',
    bg2 = '#363944',
    grey = '#7f8490',
    border = '#80A0C2',
}

highlight({

    ---------- HIGHLIGHTING GROUPS ----------

    ColorColumn = { bg = c.grey },
    Conceal = {},
    Cursor = { reverse = true },
    CursorColumn = { bg = c.bg },
    CursorLine = { fg = c.red, bg = c.bg },
    CursorLineNr = { fg = c.fg },
    CursorTransparent = { fg = c.bg, bg = c.bg },
    DiffAdd = { fg = c.green },
    DiffChange = { fg = c.blue },
    DiffDelete = { fg = c.red },
    DiffText = { bg = c.blue, fg = c.black },
    Directory = { fg = c.blue },
    ErrorMsg = { fg = c.red },
    FloatBorder = { fg = c.border },
    FoldColumn = {},
    Folded = { fg = c.grey },
    IncSearch = { fg = c.yellow, bg = c.grey },
    LineNr = { fg = c.grey },
    MatchParen = { fg = c.blue, underline = true },
    ModeMsg = {},
    MoreMsg = {},
    NonText = { fg = c.bg2 },
    Normal = { fg = c.fg, bg = c.bg },
    NormalFloat = { fg = c.fg, bg = c.bg },
    Pmenu = { fg = c.white, bg = c.menu_grey },
    PmenuSbar = { bg = c.grey },
    PmenuSel = { fg = c.grey, bg = c.blue },
    PmenuThumb = { bg = c.white },
    Question = { fg = c.purple },
    QuickFixLine = { fg = c.black, bg = c.yellow },
    Search = { fg = c.black, bg = c.yellow },
    SignColumn = {},
    SpecialKey = { fg = c.grey },
    SpellBad = { fg = c.red, underline = true },
    SpellCap = { fg = c.dark_yellow },
    SpellLocal = { fg = c.dark_yellow },
    SpellRare = { fg = c.dark_yellow },
    StatusLine = { fg = c.white, bg = c.grey },
    StatusLineNC = { fg = c.grey },
    StatusLineTerm = { fg = c.white, bg = c.grey },
    StatusLineTermNC = { fg = c.grey },
    TabLine = { fg = c.grey },
    TabLineFill = {},
    TabLineSel = { fg = c.white },
    Terminal = { fg = c.white, bg = c.black },
    Title = { fg = c.green },
    VertSplit = { fg = c.grey },
    Visual = { bg = c.bg2 },
    VisualNOS = { bg = c.grey },
    WarningMsg = { fg = c.yellow },
    Whitespace = { fg = c.bg2 },
    WildMenu = { fg = c.black, bg = c.blue },
    iCursor = { link = 'Cursor' },
    lCursor = { link = 'Cursor' },
    vCursor = { link = 'Cursor' },

    ---------- SYNTAX GROUP NAMES ----------

    Boolean = { fg = c.dark_yellow },
    Character = { fg = c.green },
    Comment = { fg = c.grey, italic = true },
    Conditional = { fg = c.purple },
    Constant = { fg = c.cyan },
    Debug = {},
    Define = { fg = c.purple },
    Delimiter = {},
    Error = { fg = c.red },
    Exception = { fg = c.purple },
    Float = { fg = c.dark_yellow },
    Function = { fg = c.blue },
    Identifier = { fg = c.red },
    Ignore = {},
    Include = { fg = c.blue },
    Keyword = { fg = c.red },
    Label = { fg = c.purple },
    Macro = { fg = c.purple },
    Number = { fg = c.dark_yellow },
    Operator = { fg = c.purple },
    PreCondit = { fg = c.yellow },
    PreProc = { fg = c.yellow },
    Repeat = { fg = c.purple },
    Special = { fg = c.blue },
    SpecialChar = { fg = c.dark_yellow },
    SpecialComment = { fg = c.grey },
    Statement = { fg = c.purple },
    StorageClass = { fg = c.yellow },
    String = { fg = c.green },
    Structure = { fg = c.yellow },
    Tag = {},
    Todo = { fg = c.purple },
    Type = { fg = c.yellow },
    Typedef = { fg = c.yellow },
    Underlined = { underline = true },

    ---------- NVIM LSPCONFIG ----------

    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.orange },
    DiagnosticInfo = { fg = c.yellow },
    DiagnosticHint = { fg = c.cyan },
    DiagnosticUnderlineError = { undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = c.orange },
    DiagnosticUnderlineInfo = { undercurl = true, sp = c.yellow },
    DiagnosticUnderlineHint = { undercurl = true, sp = c.cyan },
    LspSignatureActiveParameter = { fg = c.red },
    LspReferenceWrite = { fg = c.blue, underline = true },
    LspReferenceText = { fg = c.blue, underline = true },
    LspReferenceRead = { fg = c.blue, underline = true },

    ---------- STARTIFY ----------

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
    CmpItemKindClass = { fg = c.blue },
    CmpItemKindColor = { fg = c.yellow },
    CmpItemKindConstant = { link = 'TSConstant' },
    CmpItemKindConstructor = { link = 'TSConstructor' },
    CmpItemKindEnum = { fg = c.blue },
    CmpItemKindEnumMember = { fg = c.purple },
    CmpItemKindEvent = { fg = c.red },
    CmpItemKindField = { link = 'TSField' },
    CmpItemKindFile = { fg = c.yellow },
    CmpItemKindFolder = { fg = c.yellow },
    CmpItemKindFunction = { link = 'TSFunction' },
    CmpItemKindInterface = { fg = c.blue },
    CmpItemKindKeyword = { link = 'TSKeyword' },
    CmpItemKindMethod = { link = 'TSMethod' },
    CmpItemKindModule = { fg = c.blue },
    CmpItemKindOperator = { link = 'TSOperator' },
    CmpItemKindProperty = { link = 'TSProperty' },
    CmpItemKindReference = { fg = c.yellow },
    CmpItemKindSnippet = { fg = c.yellow },
    CmpItemKindStruct = { link = 'TSType' },
    CmpItemKindText = { fg = c.fg },
    CmpItemKindTypeParameter = { link = 'TSType' },
    CmpItemKindUnit = { fg = c.purple },
    CmpItemKindValue = { fg = c.purple },
    CmpItemKindVariable = { link = 'TSVariable' },
})

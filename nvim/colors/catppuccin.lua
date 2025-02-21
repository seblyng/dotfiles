local function highlight(colors)
    for name, opts in pairs(colors) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end

local c = {
    color1 = "#89b4fb",
    color2 = "#cdd6f5",
    color3 = "#f9e2b0",
    color4 = "#45475b",
    color5 = "#1e1e2f",
    color6 = "#f38ba9",
    color7 = "#cba6f8",
    color8 = "#fab388",
    color9 = "#b4beff",
    color10 = "#f2cdce",
    color11 = "#94e2d6",
    color12 = "#a6e3a2",
    color13 = "#6c7087",
    color14 = "#eba0ad",
    color15 = "#313245",
    color16 = "#f5c2e8",
    color17 = "#89dcec",
    color18 = "#9399b3",
    color19 = "#7f849d",
    color20 = "#f5e0dd",
    color21 = "#b3f6c0",
    color22 = "#74c7ed",
    color23 = "#4f5258",
    color25 = "#ffc0b9",
    color26 = "#2a2b3d",
    color27 = "#3e4b6c",
    color28 = "#3e5768",
    color29 = "#364144",
    color33 = "#8cf8f7",
    color34 = "#7ec9d9",
    color35 = "#443245",
    color36 = "#25293d",
}

highlight({
    Added = { fg = c.color21 },
    Bold = { bold = true },
    Boolean = { fg = c.color8 },
    Changed = { fg = c.color33 },
    Character = { fg = c.color11 },
    CmpItemAbbr = { fg = c.color18 },
    CmpItemAbbrDeprecated = { fg = c.color13, strikethrough = true },
    CmpItemAbbrMatch = { bold = true, fg = c.color2 },
    CmpItemAbbrMatchFuzzy = { bold = true, fg = c.color2 },
    CmpItemKind = { fg = c.color1 },
    CmpItemKindClass = { fg = c.color3 },
    CmpItemKindColor = { fg = c.color6 },
    CmpItemKindConstant = { fg = c.color8 },
    CmpItemKindConstructor = { fg = c.color1 },
    CmpItemKindCopilot = { fg = c.color11 },
    CmpItemKindEnum = { fg = c.color12 },
    CmpItemKindEnumMember = { fg = c.color6 },
    CmpItemKindEvent = { fg = c.color1 },
    CmpItemKindField = { fg = c.color12 },
    CmpItemKindFile = { fg = c.color1 },
    CmpItemKindFolder = { fg = c.color1 },
    CmpItemKindFunction = { fg = c.color1 },
    CmpItemKindInterface = { fg = c.color3 },
    CmpItemKindKeyword = { fg = c.color6 },
    CmpItemKindMethod = { fg = c.color1 },
    CmpItemKindModule = { fg = c.color1 },
    CmpItemKindOperator = { fg = c.color1 },
    CmpItemKindProperty = { fg = c.color12 },
    CmpItemKindReference = { fg = c.color6 },
    CmpItemKindSnippet = { fg = c.color7 },
    CmpItemKindStruct = { fg = c.color1 },
    CmpItemKindText = { fg = c.color11 },
    CmpItemKindTypeParameter = { fg = c.color1 },
    CmpItemKindUnit = { fg = c.color12 },
    CmpItemKindValue = { fg = c.color8 },
    CmpItemKindVariable = { fg = c.color10 },
    CmpItemMenu = { fg = c.color2 },
    ColorColumn = { bg = c.color5 },
    Comment = { fg = c.color13, italic = true },
    Conceal = { fg = c.color19 },
    Conditional = { fg = c.color7, italic = true },
    Constant = { fg = c.color8 },
    CurSearch = { bg = c.color6, fg = c.color15 },
    Cursor = { bg = c.color2, fg = c.color5 },
    CursorColumn = { bg = c.color15 },
    CursorIM = { bg = c.color2, fg = c.color5 },
    CursorLine = { bg = c.color26 },
    CursorLineFold = { link = "FoldColumn" },
    CursorLineNr = { fg = c.color9 },
    CursorLineSign = { link = "SignColumn" },
    DapBreakpoint = { fg = c.color6 },
    DapBreakpointCondition = { fg = c.color3 },
    DapBreakpointRejected = { fg = c.color7 },
    DapLogPoint = { fg = c.color17 },
    DapStopped = { fg = c.color14 },
    Debug = { link = "Special" },
    Define = { link = "PreProc" },
    Delimiter = { fg = c.color18 },
    DiagnosticDeprecated = { sp = c.color25, strikethrough = true },
    DiagnosticError = { fg = c.color6, italic = true },
    DiagnosticHint = { fg = c.color11, italic = true },
    DiagnosticInfo = { fg = c.color17, italic = true },
    DiagnosticOk = { fg = c.color21 },
    DiagnosticUnderlineError = { sp = c.color6, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.color11, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.color17, undercurl = true },
    DiagnosticUnderlineOk = { sp = c.color21, underline = true },
    DiagnosticUnderlineWarn = { sp = c.color3, undercurl = true },
    DiagnosticUnnecessary = { link = "Comment" },
    DiagnosticWarn = { fg = c.color3, italic = true },
    DiffAdd = { bg = c.color29 },
    DiffChange = { bg = c.color36 },
    DiffDelete = { bg = c.color35 },
    DiffText = { bg = c.color27 },
    Directory = { fg = c.color1 },
    EndOfBuffer = { fg = c.color5 },
    Error = { fg = c.color6 },
    ErrorMsg = { bold = true, fg = c.color6, italic = true },
    Exception = { fg = c.color7 },
    Float = { link = "Number" },
    FloatBorder = { fg = c.color15 },
    FloatFooter = { link = "FloatTitle" },
    FloatShadow = { bg = c.color23, blend = 80 },
    FloatShadowThrough = { bg = c.color23, blend = 100 },
    FloatTitle = { fg = c.color2 },
    FoldColumn = { fg = c.color13 },
    Folded = { bg = c.color4, fg = c.color1 },
    Function = { fg = c.color1 },
    GitSignsAddInline = { default = true, link = "TermCursor" },
    GitSignsAddLn = { default = true, link = "DiffAdd" },
    GitSignsDeleteInline = { default = true, link = "TermCursor" },
    Identifier = { fg = c.color10 },
    Ignore = { link = "Normal" },
    IncSearch = { bg = c.color34, fg = c.color15 },
    Include = { fg = c.color7 },
    Italic = { italic = true },
    Keyword = { fg = c.color7 },
    Label = { fg = c.color22 },
    LineNr = { fg = c.color4 },
    LineNrAbove = { link = "LineNr" },
    LineNrBelow = { link = "LineNr" },
    LspCodeLens = { fg = c.color13 },
    LspInlayHint = { bg = c.color26, fg = c.color13 },
    LspReferenceRead = { bg = c.color4 },
    LspReferenceText = { bg = c.color4 },
    LspReferenceWrite = { bg = c.color4 },
    LspSignatureActiveParameter = { fg = c.color8 },
    Macro = { fg = c.color7 },
    MatchParen = { bg = c.color4, bold = true, fg = c.color8 },
    ModeMsg = { bold = true, fg = c.color2 },
    MoreMsg = { fg = c.color1 },
    MsgArea = {},
    MsgSeparator = {},
    NonText = { fg = c.color13 },
    Normal = { bg = c.color5, fg = c.color2 },
    NormalFloat = { bg = c.color15, fg = c.color2 },
    NormalNC = { bg = c.color5, fg = c.color2 },
    Number = { fg = c.color8 },
    Operator = { fg = c.color17 },
    Pmenu = { bg = c.color15, fg = c.color18 },
    PmenuExtra = { link = "Pmenu" },
    PmenuExtraSel = { link = "PmenuSel" },
    PmenuKind = { link = "Pmenu" },
    PmenuKindSel = { link = "PmenuSel" },
    PmenuMatch = { fg = c.color2, bg = c.color15 },
    PmenuMatchSel = { fg = c.color2, bg = c.color4 },
    PmenuSbar = { bg = c.color4 },
    PmenuSel = { fg = c.color18, bg = c.color4, bold = true },
    PmenuThumb = { bg = c.color13 },
    PreCondit = { link = "PreProc" },
    PreProc = { fg = c.color16 },
    Question = { fg = c.color1 },
    QuickFixLine = { bg = c.color4, bold = true },
    Removed = { fg = c.color25 },
    Repeat = { fg = c.color7 },
    Search = { bg = c.color28, fg = c.color2 },
    SignColumn = { fg = c.color4 },
    SnippetTabstop = { link = "Visual" },
    Special = { fg = c.color16 },
    SpecialChar = { link = "Special" },
    SpecialComment = { link = "Special" },
    SpecialKey = { link = "NonText" },
    SpellBad = { sp = c.color6, undercurl = true },
    SpellCap = { sp = c.color3, undercurl = true },
    SpellLocal = { sp = c.color1, undercurl = true },
    SpellRare = { sp = c.color12, undercurl = true },
    StartifyBracket = { link = "Delimiter" },
    StartifyEndOfBuffer = { fg = c.color5 },
    StartifyFile = { link = "Identifier" },
    StartifyFooter = { link = "Title" },
    StartifyHeader = { link = "Title" },
    StartifyNumber = { link = "Number" },
    StartifyPath = { link = "Directory" },
    StartifySection = { link = "Statement" },
    StartifySelect = { link = "Title" },
    StartifySlash = { link = "Delimiter" },
    StartifySpecial = { link = "Comment" },
    StartifyVar = { link = "StartifyPath" },
    Statement = { fg = c.color7 },
    StatusLine = { bg = c.color15, fg = c.color2 },
    StatusLineNC = { bg = c.color15, fg = c.color4 },
    StorageClass = { fg = c.color3 },
    String = { fg = c.color12 },
    Structure = { fg = c.color3 },
    Substitute = { bg = c.color4, fg = c.color16 },
    TabLine = {},
    TabLineFill = {},
    TabLineSel = { bg = c.color4, fg = c.color12 },
    Tag = { bold = true, fg = c.color9 },
    TermCursor = { reverse = true },
    TermCursorNC = {},
    Title = { bold = true, fg = c.color1 },
    Todo = { bg = c.color10, bold = true, fg = c.color5 },
    Type = { fg = c.color3 },
    Typedef = { link = "Type" },
    Underlined = { underline = true },
    VertSplit = { fg = c.color2 },
    Visual = { bg = c.color4, bold = true },
    VisualNOS = { bg = c.color4, bold = true },
    WarningMsg = { fg = c.color3 },
    Whitespace = { fg = c.color4 },
    WildMenu = { bg = c.color13 },
    WinBar = { fg = c.color20 },
    WinBarNC = { link = "WinBar" },
    WinSeparator = { fg = c.color2 },
    ["@attribute"] = { link = "Constant" },
    ["@boolean"] = { link = "Boolean" },
    ["@character"] = { link = "Character" },
    ["@character.special"] = { link = "SpecialChar" },
    ["@comment"] = { link = "Comment" },
    ["@comment.error"] = { bg = c.color6, fg = c.color5 },
    ["@comment.hint"] = { bg = c.color1, fg = c.color5 },
    ["@comment.note"] = { bg = c.color1, fg = c.color5 },
    ["@comment.todo"] = { bg = c.color10, fg = c.color5 },
    ["@comment.warning"] = { bg = c.color3, fg = c.color5 },
    ["@comment.warning.gitcommit"] = { fg = c.color3 },
    ["@conditional"] = { link = "Conditional" },
    ["@constant"] = { link = "Constant" },
    ["@constant.builtin"] = { fg = c.color8 },
    ["@constant.java"] = { fg = c.color11 },
    ["@constant.macro"] = { link = "Macro" },
    ["@constructor"] = { fg = c.color22 },
    ["@constructor.lua"] = { fg = c.color10 },
    ["@constructor.tsx"] = { fg = c.color9 },
    ["@constructor.typescript"] = { fg = c.color9 },
    ["@define"] = { link = "Define" },
    ["@diff.delta"] = { fg = c.color1 },
    ["@diff.minus"] = { fg = c.color6 },
    ["@diff.plus"] = { fg = c.color12 },
    ["@error"] = { link = "Error" },
    ["@exception"] = { link = "Exception" },
    ["@field"] = { fg = c.color9 },
    ["@float"] = { link = "Float" },
    ["@function"] = { link = "Function" },
    ["@function.builtin"] = { fg = c.color8 },
    ["@function.builtin.bash"] = { fg = c.color6, italic = true },
    ["@function.call"] = { link = "Function" },
    ["@function.macro"] = { fg = c.color11 },
    ["@function.method"] = { link = "Function" },
    ["@function.method.call"] = { link = "Function" },
    ["@function.method.call.php"] = { link = "Function" },
    ["@function.method.php"] = { link = "Function" },
    ["@include"] = { link = "Include" },
    ["@keyword"] = { link = "Keyword" },
    ["@keyword.conditional"] = { link = "Conditional" },
    ["@keyword.directive"] = { link = "PreProc" },
    ["@keyword.directive.define"] = { link = "Define" },
    ["@keyword.exception"] = { link = "Exception" },
    ["@keyword.export"] = { fg = c.color17 },
    ["@keyword.function"] = { fg = c.color7 },
    ["@keyword.import"] = { link = "Include" },
    ["@keyword.operator"] = { fg = c.color7 },
    ["@keyword.repeat"] = { link = "Repeat" },
    ["@keyword.return"] = { fg = c.color7 },
    ["@keyword.storage"] = { link = "StorageClass" },
    ["@label"] = { link = "Label" },
    ["@label.json"] = { fg = c.color1 },
    ["@lsp.type.boolean"] = { link = "@boolean" },
    ["@lsp.type.builtinType"] = { link = "@type.builtin" },
    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.comment"] = { link = "@comment" },
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.escapeSequence"] = { link = "@string.escape" },
    ["@lsp.type.formatSpecifier"] = { link = "@punctuation.special" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { fg = c.color10 },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.macro"] = { link = "@constant.macro" },
    ["@lsp.type.method"] = { link = "@function.method" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.number"] = { link = "@number" },
    ["@lsp.type.operator"] = { link = "@operator" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.selfKeyword"] = { link = "@variable.builtin" },
    ["@lsp.type.struct"] = { link = "@type" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeAlias"] = { link = "@type.definition" },
    ["@lsp.type.typeParameter"] = { link = "@type.definition" },
    ["@lsp.type.unresolvedReference"] = { link = "@error" },
    ["@lsp.type.variable"] = {},
    ["@lsp.typemod.class.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.enum.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.keyword.async"] = {},
    ["@lsp.typemod.macro.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.operator.injected"] = { link = "@operator" },
    ["@lsp.typemod.string.injected"] = { link = "@string" },
    ["@lsp.typemod.type.defaultLibrary"] = { link = "@type.builtin" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.injected"] = { link = "@variable" },
    ["@markup"] = { fg = c.color2 },
    ["@markup.environment"] = { fg = c.color16 },
    ["@markup.environment.name"] = { fg = c.color1 },
    ["@markup.heading"] = { bold = true, fg = c.color1 },
    ["@markup.heading.1.markdown"] = { fg = c.color6 },
    ["@markup.heading.2.markdown"] = { fg = c.color8 },
    ["@markup.heading.3.markdown"] = { fg = c.color3 },
    ["@markup.heading.4.markdown"] = { fg = c.color12 },
    ["@markup.heading.5.markdown"] = { fg = c.color22 },
    ["@markup.heading.6.markdown"] = { fg = c.color9 },
    ["@markup.italic"] = { fg = c.color14, italic = true },
    ["@markup.link"] = { link = "Tag" },
    ["@markup.link.url"] = { fg = c.color20, italic = true, underline = true },
    ["@markup.list"] = { link = "Special" },
    ["@markup.list.checked"] = { fg = c.color12 },
    ["@markup.list.unchecked"] = { fg = c.color19 },
    ["@markup.math"] = { fg = c.color1 },
    ["@markup.raw"] = { fg = c.color11 },
    ["@markup.strikethrough"] = { fg = c.color2, strikethrough = true },
    ["@markup.strong"] = { bold = true, fg = c.color14 },
    ["@markup.underline"] = { link = "Underlined" },
    ["@method"] = { link = "Function" },
    ["@method.call"] = { link = "Function" },
    ["@method.call.php"] = { link = "Function" },
    ["@method.php"] = { link = "Function" },
    ["@module"] = { fg = c.color9, italic = true },
    ["@module.builtin"] = { link = "Special" },
    ["@namespace"] = { fg = c.color9, italic = true },
    ["@number"] = { link = "Number" },
    ["@number.css"] = { fg = c.color8 },
    ["@number.float"] = { link = "Float" },
    ["@operator"] = { link = "Operator" },
    ["@parameter"] = { fg = c.color14 },
    ["@preproc"] = { link = "PreProc" },
    ["@property"] = { fg = c.color9 },
    ["@property.class.css"] = { fg = c.color3 },
    ["@property.cpp"] = { fg = c.color2 },
    ["@property.css"] = { fg = c.color9 },
    ["@property.id.css"] = { fg = c.color1 },
    ["@property.toml"] = { fg = c.color1 },
    ["@property.typescript"] = { fg = c.color9 },
    ["@punctuation"] = { link = "Delimiter" },
    ["@punctuation.bracket"] = { fg = c.color18 },
    ["@punctuation.delimiter"] = { link = "Delimiter" },
    ["@punctuation.special"] = { link = "Special" },
    ["@repeat"] = { link = "Repeat" },
    ["@storageclass"] = { link = "StorageClass" },
    ["@string"] = { link = "String" },
    ["@string.escape"] = { fg = c.color16 },
    ["@string.plain.css"] = { fg = c.color8 },
    ["@string.regex"] = { fg = c.color8 },
    ["@string.regexp"] = { fg = c.color8 },
    ["@string.special"] = { link = "Special" },
    ["@string.special.symbol"] = { fg = c.color10 },
    ["@string.special.symbol.ruby"] = { fg = c.color10 },
    ["@string.special.url"] = { fg = c.color20, italic = true, underline = true },
    ["@symbol"] = { fg = c.color10 },
    ["@symbol.ruby"] = { fg = c.color10 },
    ["@tag"] = { fg = c.color7 },
    ["@tag.attribute"] = { fg = c.color11, italic = true },
    ["@tag.attribute.tsx"] = { fg = c.color11, italic = true },
    ["@tag.delimiter"] = { fg = c.color17 },
    ["@text"] = { fg = c.color2 },
    ["@text.danger"] = { bg = c.color6, fg = c.color5 },
    ["@text.diff.add"] = { fg = c.color12 },
    ["@text.diff.delete"] = { fg = c.color6 },
    ["@text.emphasis"] = { fg = c.color14, italic = true },
    ["@text.environment"] = { fg = c.color16 },
    ["@text.environment.name"] = { fg = c.color1 },
    ["@text.literal"] = { fg = c.color11 },
    ["@text.math"] = { fg = c.color1 },
    ["@text.note"] = { bg = c.color1, fg = c.color5 },
    ["@text.reference"] = { link = "Tag" },
    ["@text.strike"] = { fg = c.color2, strikethrough = true },
    ["@text.strong"] = { bold = true, fg = c.color14 },
    ["@text.title"] = { bold = true, fg = c.color1 },
    ["@text.title.1.markdown"] = { fg = c.color6 },
    ["@text.title.2.markdown"] = { fg = c.color8 },
    ["@text.title.3.markdown"] = { fg = c.color3 },
    ["@text.title.4.markdown"] = { fg = c.color12 },
    ["@text.title.5.markdown"] = { fg = c.color22 },
    ["@text.title.6.markdown"] = { fg = c.color9 },
    ["@text.todo"] = { bg = c.color10, fg = c.color5 },
    ["@text.todo.checked"] = { fg = c.color12 },
    ["@text.todo.unchecked"] = { fg = c.color19 },
    ["@text.underline"] = { link = "Underlined" },
    ["@text.warning"] = { bg = c.color3, fg = c.color5 },
    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { fg = c.color3 },
    ["@type.builtin.c"] = { fg = c.color3 },
    ["@type.builtin.cpp"] = { fg = c.color3 },
    ["@type.css"] = { fg = c.color9 },
    ["@type.definition"] = { link = "Type" },
    ["@type.qualifier"] = { link = "Keyword" },
    ["@type.tag.css"] = { fg = c.color7 },
    ["@variable"] = { fg = c.color2 },
    ["@variable.builtin"] = { fg = c.color6 },
    ["@variable.member"] = { fg = c.color9 },
    ["@variable.parameter"] = { fg = c.color14 },

    SnacksPicker = { link = "Normal" },
    SnacksPickerBorder = { fg = c.color2 },
    BlinkCmpMenuBorder = { link = "FloatBorder" },
    BlinkCmpDocBorder = { link = "FloatBorder" },
})

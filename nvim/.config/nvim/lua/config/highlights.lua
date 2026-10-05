local c = require("config.palette")
local highlights = {}
local function groups(names, color, styles)
	for _, name in ipairs(names) do
		highlights[name] = vim.tbl_extend("force", { fg = color }, styles or {})
	end
end

-- Código: Tree-sitter e tokens semânticos LSP usam as mesmas categorias.
groups({
	"@keyword",
	"@keyword.function",
	"@keyword.return",
	"@keyword.conditional",
	"@keyword.repeat",
	"@keyword.import",
	"@keyword.type",
	"@keyword.modifier",
	"@keyword.coroutine",
	"@keyword.exception",
	"@keyword.operator",
	"@keyword.directive",
	"@keyword.directive.define",
	"@variable.builtin",
	"@type.return",
	"@type.property",
	"@lsp.type.keyword",
	"@lsp.type.controlKeyword",
	"@lsp.type.modifier",
}, c.red, { bold = true })
groups({ "@keyword.accessor", "@keyword.private" }, c.dark_gray)
groups({
	"@type",
	"@type.builtin",
	"@type.parameter",
	"@type.local",
	"@variable",
	"@number",
	"@number.float",
	"@boolean",
	"@constant",
	"@constant.builtin",
	"@constant.macro",
	"@lsp.type.type",
	"@lsp.type.typeParameter",
	"@lsp.type.variable",
	"@lsp.type.number",
	"@lsp.type.constant",
	"@lsp.type.enumMember",
}, c.dark_red)
groups({
	"@type.definition",
	"@constructor",
	"@function",
	"@function.method",
	"@lsp.type.class",
	"@lsp.type.interface",
	"@lsp.type.struct",
	"@lsp.type.enum",
	"@lsp.type.delegate",
	"@lsp.type.recordClass",
	"@lsp.type.recordStruct",
}, c.orange, { bold = true })
groups({
	"@function.call",
	"@function.builtin",
	"@function.method.call",
	"@function.macro",
	"@lsp.type.method",
	"@lsp.type.function",
	"@lsp.type.extensionMethod",
	"@lsp.type.functionPointer",
}, c.dark_orange, { bold = true })
groups({
	"@variable.parameter",
	"@string",
	"@string.escape",
	"@character",
	"@lsp.type.parameter",
	"@lsp.type.string",
	"@lsp.type.stringVerbatim",
	"@lsp.type.stringEscapeCharacter",
	"@module",
	"@lsp.type.namespace",
}, c.light_gray)
groups({
	"@property",
	"@variable.member",
	"@lsp.type.property",
	"@lsp.type.field",
	"@lsp.type.event",
}, c.white, { italic = false })
groups({
	"@operator",
	"@punctuation.delimiter",
	"@punctuation.bracket",
	"@punctuation.special",
	"@keyword.conditional.ternary",
	"@lsp.type.operator",
	"@lsp.type.operatorOverloaded",
	"@lsp.type.punctuation",
}, c.gray)
groups({ "@comment", "@comment.documentation", "@lsp.type.comment" }, c.dark_gray, { italic = true })
groups({
	"@string.regexp",
	"@lsp.type.regexp",
	"@lsp.type.regexAlternation",
	"@lsp.type.regexAnchor",
	"@lsp.type.regexCharacterClass",
	"@lsp.type.regexComment",
	"@lsp.type.regexGrouping",
	"@lsp.type.regexOtherEscape",
	"@lsp.type.regexQuantifier",
	"@lsp.type.regexSelfEscapedCharacter",
	"@lsp.type.regexText",
}, c.dark_gray)

-- Sintaxe tradicional e capturas de linguagens de marcação/configuração.
groups({
	"Keyword",
	"Statement",
	"Conditional",
	"Repeat",
	"Exception",
	"PreProc",
	"Include",
	"Define",
	"StorageClass",
	"Label",
	"@tag",
	"@tag.builtin",
	"@keyword.storage",
}, c.red, { bold = true })
groups({
	"Type",
	"Number",
	"Float",
	"Boolean",
	"Constant",
	"Identifier",
	"@lsp.type.builtinConstant",
	"@lsp.type.boolean",
	"@lsp.type.array",
	"@lsp.type.pointer",
}, c.dark_red)
groups({
	"Function",
	"Structure",
	"Typedef",
	"@attribute",
	"@attribute.builtin",
	"@lsp.type.decorator",
	"@lsp.type.macro",
	"@lsp.type.label",
}, c.orange, { bold = true })
groups({
	"String",
	"Character",
	"@string.special",
	"@string.special.path",
	"@string.special.url",
	"@string.special.symbol",
	"@string.documentation",
	"@lsp.type.module",
	"@lsp.type.selfParameter",
}, c.light_gray)
groups({ "Operator", "Delimiter", "SpecialChar", "@tag.delimiter", "@character.special" }, c.gray)
groups({
	"Comment",
	"@comment.todo",
	"@comment.note",
	"@comment.documentation",
	"@lsp.type.excludedCode",
	"@lsp.type.preprocessorText",
}, c.dark_gray, { italic = true })
groups({ "@tag.attribute", "@lsp.type.jsonPropertyName" }, c.white)
groups({ "@markup.heading", "Title" }, c.red, { bold = true })
groups({ "@markup.link", "@markup.link.label" }, c.orange, { underline = true })
groups({ "@markup.raw", "@markup.list", "@markup.link.url" }, c.gray)
groups({ "@markup.strong" }, c.white, { bold = true })
groups({ "@markup.italic" }, c.light_gray, { italic = true })
highlights["@lsp.mod.readonly"] = {}
highlights["@lsp.mod.static"] = {}
highlights["@lsp.mod.ReassignedVariable"] = { underline = true }
highlights["@lsp.mod.deprecated"] = { strikethrough = true }
-- O Ashen cria este grupo azul específico ao conectar o gopls.
highlights["@lsp.typemod.variable.readonly"] = { fg = c.dark_red }
for _, kind in ipairs({ "function", "method", "class", "struct", "interface", "enum" }) do
	for _, modifier in ipairs({ "declaration", "definition" }) do
		highlights["@lsp.typemod." .. kind .. "." .. modifier] = { fg = c.orange, bold = true }
	end
end

-- As definições específicas de linguagem não podem recolocar as cores do tema.
local languages = {
	"c_sharp",
	"c",
	"go",
	"javascript",
	"typescript",
	"tsx",
	"python",
	"java",
	"lua",
	"json",
	"html",
	"css",
	"markdown",
	"markdown_inline",
	"bash",
	"yaml",
	"toml",
	"vim",
	"regex",
}
local filetypes = {
	"cs",
	"c",
	"cpp",
	"go",
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"python",
	"java",
	"lua",
	"json",
	"jsonc",
	"html",
	"css",
	"markdown",
	"sh",
	"yaml",
	"toml",
	"vim",
}
local syntax = vim.deepcopy(highlights)
for name, definition in pairs(syntax) do
	if name:sub(1, 1) == "@" then
		local scopes = name:match("^@lsp%.") and filetypes or languages
		for _, scope in ipairs(scopes) do
			highlights[name .. "." .. scope] = vim.deepcopy(definition)
		end
	end
end

-- O parser injetado de regex colore toda a expressão em cinza escuro.
for name in pairs(syntax) do
	if name:sub(1, 1) == "@" and not name:match("^@lsp%.") then
		highlights[name .. ".regex"] = { fg = c.dark_gray }
	end
end

-- Editor: texto claro, bordas neutras e seleção sem blocos vermelhos.
groups(
	{ "Normal", "NormalNC", "NormalFloat", "Pmenu", "StatusLine", "TabLine", "TabLineFill" },
	c.white,
	{ bg = "NONE" }
)
groups({
	"FloatBorder",
	"WinSeparator",
	"PmenuBorder",
	"NonText",
	"SpecialKey",
	"LineNr",
	"StatusLineNC",
	"Directory",
	"Whitespace",
	"Folded",
}, c.gray, { bg = "NONE" })
groups(
	{ "CursorLineNr", "FloatTitle", "TabLineSel", "PmenuSel", "PmenuMatchSel" },
	c.selected,
	{ bg = "NONE", bold = true }
)
highlights.CursorLine = { bg = c.line }
highlights.Visual = { bg = c.line }
highlights.Search = { fg = c.orange, bg = c.line }
highlights.IncSearch = { fg = c.red, bg = c.line, bold = true }
highlights.CurSearch = { fg = c.red, bg = c.line, bold = true }
highlights.MatchParen = { fg = c.orange, bg = c.line, bold = true }
highlights.AshenYank = { bg = c.line }
highlights.ErrorMsg = { fg = c.error, bg = "NONE", bold = true }
highlights.WarningMsg = { fg = c.warning, bg = "NONE" }
for severity, color in pairs({ Error = c.error, Warn = c.warning, Info = c.light_gray, Hint = c.dark_gray }) do
	groups({
		"Diagnostic" .. severity,
		"DiagnosticSign" .. severity,
		"DiagnosticFloating" .. severity,
		"DiagnosticVirtualText" .. severity,
		"DiagnosticVirtualLines" .. severity,
	}, color, { bg = "NONE" })
	highlights["DiagnosticUnderline" .. severity] = { sp = color, underdotted = true }
end

-- Explorer: azul de erro prevalece sobre o nome selecionado laranja.
groups({ "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeCursorLine" }, c.white, { bg = "NONE" })
groups({ "NvimTreeRootFolder" }, c.red, { bold = true })
groups({ "NvimTreeSelectedName" }, c.selected, { bold = true })
groups({
	"NvimTreeFolderName",
	"NvimTreeEmptyFolderName",
	"NvimTreeOpenedFolderName",
	"NvimTreeSpecialFolderName",
	"NvimTreeSymlinkFolderName",
	"NvimTreeHiddenFolderHL",
	"NvimTreeModifiedFolderHL",
	"NvimTreeFolderArrowClosed",
	"NvimTreeFolderArrowOpen",
	"NvimTreeIndentMarker",
}, c.gray)
groups({
	"NvimTreeFileIcon",
	"NvimTreeSymlinkIcon",
	"NvimTreeFolderIcon",
	"NvimTreeClosedFolderIcon",
	"NvimTreeOpenedFolderIcon",
	"NvimTreeGitNewIcon",
}, c.icon)
groups({ "NvimTreeExecFile", "NvimTreeImageFile", "NvimTreeSpecialFile", "NvimTreeSymlink" }, c.white)
groups({ "NvimTreeOpenedHL" }, c.light_gray, { underline = true })
groups({ "NvimTreeHiddenFileHL" }, c.dark_gray, { italic = true })
groups({ "NvimTreeModifiedIcon", "NvimTreeModifiedFileHL" }, c.orange, { bold = true })
for state, color in pairs({
	Staged = c.light_gray,
	Dirty = c.orange,
	Deleted = c.dark_red,
	Ignored = c.dark_gray,
	New = c.icon,
	Renamed = c.orange,
	Merge = c.warning,
}) do
	groups({ "NvimTreeGit" .. state .. "Icon", "NvimTreeGitFile" .. state .. "HL" }, color)
	groups({ "NvimTreeGitFolder" .. state .. "HL" }, c.gray)
end
for _, severity in ipairs({ "Error", "Warn", "Info", "Hint" }) do
	local color = severity == "Error" and c.error or severity == "Warn" and c.warning or c.gray
	groups({
		"NvimTreeDiagnostic" .. severity .. "Icon",
		"NvimTreeDiagnostic" .. severity .. "FileHL",
		"NvimTreeDiagnostic" .. severity .. "FolderHL",
	}, color, { bold = severity == "Error" })
end

-- Ferramentas: texto claro, nomes selecionados vermelhos e ícones laranja.
groups({
	"BlinkCmpMenu",
	"BlinkCmpDoc",
	"BlinkCmpSignatureHelp",
	"BlinkCmpLabel",
	"NoiceCmdlinePopup",
	"NoicePopupmenu",
	"NoicePopup",
	"TroubleNormal",
	"TroubleNormalNC",
	"TroubleText",
	"FzfLuaNormal",
	"DashboardDesc",
	"WhichKeyDesc",
	"DapUINormal",
	"DapUIFloatNormal",
	"NeotestNormal",
	"LazyNormal",
	"MasonNormal",
	"SnacksNormal",
	"SnacksTerminal",
	"NotifyBackground",
}, c.light_gray, { bg = "NONE" })
groups({
	"BlinkCmpMenuBorder",
	"BlinkCmpDocBorder",
	"BlinkCmpSignatureHelpBorder",
	"NoiceCmdlinePopupBorder",
	"NoicePopupmenuBorder",
	"NoicePopupBorder",
	"FzfLuaBorder",
	"FzfLuaPreviewBorder",
	"WhichKeyBorder",
	"DapUIFloatBorder",
	"SnacksBorder",
	"SnacksTerminalBorder",
}, c.gray, { bg = "NONE" })
groups({
	"BlinkCmpMenuSelection",
	"NoicePopupmenuSelected",
	"FzfLuaFzfCursorLine",
	"FzfLuaFzfPointer",
	"FzfLuaCursor",
	"TroubleCursor",
	"TroublePreview",
	"WhichKeyValue",
	"DapUIStoppedThread",
	"DapUICurrentFrameName",
	"NeotestTarget",
	"LazyButtonActive",
	"MasonHighlight",
}, c.selected, { bg = "NONE", bold = true })
groups({
	"BlinkCmpKind",
	"NoiceCmdlineIcon",
	"NoiceCmdlineIconSearch",
	"NoiceCompletionItemKindDefault",
	"DashboardIcon",
	"DashboardShortCut",
	"WhichKeyIcon",
	"TroubleIconDirectory",
	"FzfLuaFzfMarker",
}, c.icon)
groups({
	"BlinkCmpLabelMatch",
	"NoicePopupmenuMatch",
	"FzfLuaMatch",
	"FzfLuaFzfMatch",
	"FzfLuaFzfMatchSelected",
	"DashboardHeader",
	"DashboardKey",
	"WhichKey",
	"WhichKeyGroup",
	"LazySpecial",
	"MasonHeader",
	"DapUIBreakpointsCurrentLine",
}, c.red, { bold = true })
groups({
	"BlinkCmpLabelDescription",
	"BlinkCmpLabelDetail",
	"DashboardFooter",
	"WhichKeySeparator",
	"TroubleDirectory",
	"TroubleSource",
	"TroublePos",
	"TroubleIndent",
	"FzfLuaPath",
	"FzfLuaDirPart",
	"FzfLuaPathLineNr",
	"FzfLuaPathColNr",
	"FzfLuaBufNr",
	"LazyComment",
	"LazyDir",
	"NeotestSkipped",
	"NeotestDir",
	"DapUILineNumber",
	"DapUIBreakpointsDisabledLine",
	"DapUIUnavailable",
}, c.gray)
groups({
	"BlinkCmpSource",
	"TroubleFilename",
	"TroubleBasename",
	"FzfLuaFilePart",
	"NeotestFile",
	"NeotestTest",
	"DapUIFrameName",
	"DapUISource",
	"DapUIValue",
	"DapUIWatchesValue",
	"DapUIThread",
}, c.white)
groups({
	"FzfLuaTitle",
	"FzfLuaPreviewTitle",
	"NoiceCmdlinePopupTitle",
	"WhichKeyTitle",
	"NeotestNamespace",
	"LazyReasonPlugin",
	"DapUIScope",
	"DapUIModifiedValue",
}, c.orange, { bold = true })
groups({ "DapUIType", "DapUIVariable", "DapVirtualText" }, c.dark_red)
groups({ "NeotestPassed", "LazyProgressDone" }, c.light_gray)
groups({
	"DapUIPlayPause",
	"DapUIRestart",
	"DapUIStepInto",
	"DapUIStepOut",
	"DapUIStepOver",
	"DapUIStepBack",
	"DapUIStop",
	"NeotestRunning",
	"LazyProgressTodo",
}, c.orange)
groups({
	"DapUIWatchesError",
	"DapVirtualTextError",
	"NeotestFailed",
	"NoiceFormatLevelError",
	"LazyError",
	"NotifyERRORTitle",
	"NotifyERRORBorder",
	"NotifyERRORIcon",
}, c.error)
for _, color in ipairs({ "Azure", "Blue", "Cyan", "Green", "Grey", "Orange", "Purple", "Red", "Yellow" }) do
	groups({ "WhichKeyIcon" .. color }, c.icon)
end
for _, kind in ipairs({
	"Text",
	"Method",
	"Function",
	"Constructor",
	"Field",
	"Variable",
	"Class",
	"Interface",
	"Module",
	"Property",
	"Unit",
	"Value",
	"Enum",
	"Keyword",
	"Snippet",
	"Color",
	"File",
	"Reference",
	"Folder",
	"EnumMember",
	"Constant",
	"Struct",
	"Event",
	"Operator",
	"TypeParameter",
	"Array",
	"Boolean",
	"Namespace",
	"Null",
	"Number",
	"Object",
	"String",
	"Package",
	"Key",
}) do
	groups({ "BlinkCmpKind" .. kind, "TroubleIcon" .. kind, "NoiceCompletionItemKind" .. kind }, c.icon)
end

-- Git usa símbolos para o estado, com a mesma família de cores da interface.
for kind, color in pairs({
	Add = c.light_gray,
	Change = c.orange,
	Delete = c.dark_red,
	Changedelete = c.orange,
	Topdelete = c.dark_red,
	Untracked = c.icon,
}) do
	groups({ "GitSigns" .. kind, "GitSigns" .. kind .. "Nr" }, color)
end
highlights.DiffAdd = { fg = c.light_gray, bg = c.line }
highlights.DiffChange = { fg = c.orange, bg = c.line }
highlights.DiffDelete = { fg = c.dark_red, bg = c.line }
highlights.DiffText = { fg = c.red, bg = c.line, bold = true }
return highlights

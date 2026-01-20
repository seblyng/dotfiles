---------- INITIALIZE CONFIG ----------

vim.loader.enable()

require("vim._extui").enable({ msg = { target = "msg" } })

P = function(v)
    vim.print(v)
end

vim.diagnostic.config({
    virtual_text = { spacing = 4, prefix = "●" },
    float = { source = "if_many" },
    status = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignHint",
        },
    },
})

require("seblyng.options")
require("seblyng.keymaps")
require("seblyng.pack")
require("seblyng.autocmds")
require("seblyng.statusline")
require("seblyng.tabline")

---------- INITIALIZE CONFIG ----------

require("vim._extui").enable({ msg = { target = "msg" } })

P = function(...)
    vim.print(...)
end

require("seblyng.options")
require("seblyng.keymaps")
require("seblyng.lazy")
require("seblyng.autocmds")
require("seblyng.statusline")
require("seblyng.tabline")

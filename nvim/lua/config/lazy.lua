---------- LAZY ----------

local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

function M.conf(name)
    return function()
        local c = require(string.format("config.%s", name))
        if type(c) == "table" and c.config then
            c.config()
        end
    end
end

function M.init(name)
    return function()
        require(string.format("config.%s", name)).init()
    end
end

local dev_path = string.format("%s/projects/plugins", os.getenv("HOME"))

function M.setup(config)
    require("lazy").setup(config, {
        dev = {
            path = dev_path,
            fallback = true,
        },
        ui = {
            border = CUSTOM_BORDER,
        },
        install = {
            colorscheme = { "colorscheme" },
        },
    })
end

return M

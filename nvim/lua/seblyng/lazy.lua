local lazypath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
if not vim.uv.fs_stat(lazypath) then
    vim.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }):wait()
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy.view.config").keys.hover = "gh"
require("lazy").setup("config", {
    dev = {
        path = vim.fs.joinpath(os.getenv("HOME"), "projects", "plugins"),
        fallback = true,
    },
    ui = {
        border = vim.opt.winborder:get(),
        backdrop = 100,
    },
})

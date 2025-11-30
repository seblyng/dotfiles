-- Wrapper around vim.pack to get a few extra features I am missing by default

---@param p {spec: vim.pack.Spec, path: string}
local function load_plugin(p)
    vim.cmd.packadd({ vim.fn.escape(p.spec.name, " "), bang = vim.v.vim_did_init == 0, magic = { file = false } })

    if p.spec.data and p.spec.data.config then
        if type(p.spec.data.config) == "string" then
            require(p.spec.data.config)
        else
            p.spec.data.config()
        end
    end

    -- Super simple `opts` support similar to `lazy.nvim`
    if p.spec.data and p.spec.data.opts then
        local name = p.spec.name or p.spec.src
        local main = p.spec.data.main or name:lower():gsub("^n?vim%-", ""):gsub("%.n?vim$", ""):gsub("[%.%-]lua", "")

        local ok, mod = pcall(require, main)
        if not ok then
            vim.notify(string.format("No module found for vim.pack opts: %s", main), vim.log.levels.ERROR)
        else
            mod.setup(p.spec.data.opts)
        end
    end

    if vim.v.vim_did_enter == 1 then
        local after_paths = vim.fn.glob(p.path .. "/after/plugin/**/*.{vim,lua}", false, true)
        vim.tbl_map(function(path)
            vim.cmd.source({ path, magic = { file = false } })
        end, after_paths)
    end
end

vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("SebPack", { clear = true }),
    callback = function(ev)
        local build = ev.data.spec.data and ev.data.spec.data.build
        if not build or not vim.list_contains({ "update", "install" }, ev.data.kind) then
            return
        end

        if type(build) == "string" and build:sub(1, 1) == ":" then
            if not ev.data.active then
                load_plugin(ev.data)
            end
            vim.cmd(build)
        elseif build:match("%.lua$") then
            local chunk, err = loadfile(vim.fs.joinpath(ev.data.path, build))
            if not chunk or err then
                error(err)
            end
            chunk()
        end
    end,
})

---@param p {spec: vim.pack.Spec, path: string}
local function try_lazy_load(p)
    local data = p.spec.data or {}
    if not data.cmd and not data.event and not data.keys then
        return load_plugin(p)
    end

    if data.cmd then
        local cmds = type(data.cmd) == "string" and { data.cmd } or data.cmd
        for _, cmd in ipairs(cmds) do
            local complete = function(_, line)
                vim.api.nvim_del_user_command(cmd)
                load_plugin(p)
                return vim.fn.getcompletion(line, "cmdline")
            end

            vim.api.nvim_create_user_command(cmd, function()
                load_plugin(p)
                vim.cmd(cmd)
            end, { bang = true, range = true, nargs = "*", complete = complete })
        end
    end

    if data.keys then
        for _, key in ipairs(data.keys) do
            vim.keymap.set(key[1], key[2], function()
                vim.keymap.del(key[1], key[2])
                load_plugin(p)
                vim.api.nvim_feedkeys(vim.keycode("<Ignore>" .. key[2]), "i", false)
            end, { desc = string.format("Lazy load %s", p.spec.name) })
        end
    end

    if data.event then
        local events = type(data.event) == "string" and { data.event } or data.event
        for _, ev in ipairs(events) do
            local event, pattern = unpack(vim.split(ev, " "))
            vim.api.nvim_create_autocmd(event, {
                once = true,
                pattern = pattern or "*",
                callback = function()
                    load_plugin(p)
                end,
            })
        end
    end
end

local local_plugin_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "seb", "opt")
local plugin_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt")

-- Always clean up dev plugins which are symlinked
vim.iter(vim.fs.dir(local_plugin_dir)):each(function(name)
    local link_path = vim.fs.joinpath(local_plugin_dir, name)
    local stat = vim.uv.fs_lstat(link_path)

    if stat and stat.type == "link" then
        vim.uv.fs_unlink(link_path)
    end
end)

local add = vim.pack.add
---@diagnostic disable-next-line: duplicate-set-field
vim.pack.add = function(specs, opts)
    local remote = {}
    for _, spec in ipairs(specs) do
        if spec.data and spec.data.dev then
            spec.name = spec.name or spec.src:match("^.+/(.+)$")

            local path = vim.fs.normalize(vim.fs.joinpath("~/projects/plugins", spec.name))
            vim.fn.mkdir(local_plugin_dir, "p")
            if vim.uv.fs_stat(path) then
                if vim.uv.fs_stat(vim.fs.joinpath(plugin_dir, spec.name)) then
                    vim.pack.del({ spec.name })
                end

                vim.uv.fs_symlink(path, vim.fs.joinpath(local_plugin_dir, spec.name))

                ---@diagnostic disable-next-line: assign-type-mismatch
                try_lazy_load({ spec = spec, path = path })
            end
        else
            table.insert(remote, spec)
        end
    end

    opts = opts or {}
    opts.load = opts.load or try_lazy_load

    add(remote, opts)
end

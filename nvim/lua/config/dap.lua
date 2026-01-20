vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/igorlfs/nvim-dap-view",
})

require("dap-view").setup({
    auto_toggle = true,
    winbar = { default_section = "scopes" },
    windows = { terminal = { hide = { "coreclr" } } },
})

local function keymap(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, function()
        rhs()
        vim.fn["repeat#set"](vim.keycode(lhs))
    end, opts)
end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "Error", linehl = "DiffAdd", numhl = "" })

local dap = require("dap")

keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Dap: Add breakpoint" })
keymap("n", "<leader>d<leader>", dap.continue, { desc = "Dap: Continue debugging" })
keymap("n", "<leader>dl", dap.step_into, { desc = "Dap: Step into" })
keymap("n", "<leader>dj", dap.step_over, { desc = "Dap: Step over" })

-- C# config
dap.adapters.coreclr = {
    type = "executable",
    command = vim.fn.exepath("netcoredbg"),
    args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "Launch",
        request = "launch",
        program = function()
            local project_path = vim.fs.root(0, function(name)
                return name:match("%.csproj$") ~= nil
            end)

            if not project_path then
                return vim.notify("Couldn't find the csproj path")
            end

            return require("dap.utils").pick_file({
                filter = string.format("Debug/.*/%s", vim.fn.fnamemodify(project_path, ":t:r")),
                path = string.format("%s/bin", project_path),
            })
        end,
    },

    {
        type = "coreclr",
        name = "Attach",
        request = "attach",
        processId = function()
            return require("dap.utils").pick_process({
                filter = function(proc)
                    ---@diagnostic disable-next-line: return-type-mismatch
                    return proc.name:match(".*/Debug/.*") and not proc.name:find("vstest.console.dll")
                end,
            })
        end,
    },
}

-- Rust config
dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    name = "codelldb",
    executable = {
        command = vim.fn.exepath("codelldb"),
        args = { "--port", "${port}" },
    },
}

dap.configurations.rust = {
    {
        name = "Debug Bin",
        type = "codelldb",
        request = "launch",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        showDisassembly = "never",
        program = function()
            local client = vim.lsp.get_clients({ name = "rust_analyzer" })[1]
            local params = vim.lsp.util.make_text_document_params()
            local res = client and client:request_sync("experimental/runnables", { textDocument = params })

            if not res or not res.result then
                return vim.notify("No runnables available")
            end

            local chosen = require("dap.ui").pick_one(res.result, "Select runnable", function(item)
                return item.label
            end)

            -- Do not run when debugging
            local sanitize_args = function(args)
                if args[1] == "run" then
                    args[1] = "build"
                elseif args[1] == "test" then
                    table.insert(args, 2, "--no-run")
                end

                return args
            end

            local args = vim.list_extend(sanitize_args(chosen.args.cargoArgs), { "--message-format=json" })
            local cmd = vim.list_extend({ "cargo" }, args)
            local result = vim.system(cmd, { cwd = chosen.args.workspaceRoot }):wait()

            for _, value in pairs(vim.split(result.stdout, "\n")) do
                local ok, json = pcall(vim.json.decode, value)
                if ok and json then
                    if type(json.executable) == "string" then
                        return json.executable
                    end
                end
            end
        end,
    },
}

local function setup()
    local dap = require("dap")

    -- Adapter
    dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
            command = vim.fn.exepath("codelldb"),
            args = { "--port", "${port}" },
        },
        name = "codelldb",
    }

    -- Configration for the adapter
    dap.configurations.rust = {
        {
            name = "Debug Bin",
            type = "codelldb",
            request = "launch",
            program = function()
                local client = vim.lsp.get_clients({ name = "rust_analyzer" })[1]
                local params = vim.lsp.util.make_text_document_params()
                local res = client and client:request_sync("experimental/runnables", { textDocument = params })

                if not res or not res.result then
                    return
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
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            showDisassembly = "never",
        },
    }
end

return {
    setup = setup,
}

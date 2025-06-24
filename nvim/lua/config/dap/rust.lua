local get_cargo_cmd = function(args)
    local result = vim.list_extend({ "cargo" }, args.cargoArgs)
    table.insert(result, "--message-format=json")

    -- Prefer just building either the tests or the bin
    if result[1] == "run" then
        result[1] = "build"
    elseif result[1] == "test" then
        table.insert(result, 2, "--no-run")
    end

    for _, value in ipairs(args.cargoExtraArgs or {}) do
        if not vim.list_contains(args.cargoArgs, value) then
            table.insert(args.cargoArgs, value)
        end
    end

    return result
end

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
                if not client then
                    return
                end
                local res = client:request_sync(
                    "experimental/runnables",
                    { textDocument = vim.lsp.util.make_text_document_params() },
                    nil,
                    0
                )

                if not res or not res.result then
                    return
                end

                local chosen = require("dap.ui").pick_one(res.result, "Select runnable", function(item)
                    return item.label
                end)

                local result = vim.system(get_cargo_cmd(chosen.args), { cwd = chosen.args.workspaceRoot }):wait()

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

local TestRunner = require("seblyng.testrunner.runner")

local query = [[
      (
        (
          mod_item name: (identifier) @test-name
          (#match? @test-name "[Tt]est")
        )
      @scope-root)

      (
        (
          function_item name: (identifier) @test-name
          (#match? @test-name "[Tt]est")
        )
      @scope-root)
]]

local cargo = TestRunner:new({
    query = query,
})
function cargo:generate_cmd(captures, debug)
    -- local root = assert(vim.fs.root(0, "Cargo.toml"), "Expected to find a `Cargo.toml` file")

    local filename = vim.api.nvim_buf_get_name(0)
    local dirname = vim.fs.dirname(filename)
    local parent = vim.fn.fnamemodify(dirname, ":h")

    if vim.fs.basename(dirname) == "tests" and vim.uv.fs_stat(vim.fs.joinpath(parent, "Cargo.toml")) then
        local name = vim.fn.fnamemodify(filename, ":t:r")
        return string.format("cargo test --test %s %s -- --exact", name, table.concat(captures, "::"))
    end

    -- if string.find(filename, vim.fs.joinpath(root, "src")) then
    --     local name = vim.fn.fnamemodify(filename, ":t:r")
    --     local mod = name == "mod" and dirname or name
    --     table.insert(captures, 1, mod)
    --     return string.format("cargo test --bin %s %s -- --exact", vim.fs.basename(root), table.concat(captures, "::"))
    -- end

    return string.format("cargo test %s -- --exact", table.concat(captures, "::"))
end

return cargo

local M = {}

local default_config = {
    shell = vim.o.shell,
    width = 0.5,
    height = 0.5,
    border = "rounded",
}

local config = nil

function M.init(opts)
    config = vim.tbl_deep_extend("force", vim.deepcopy(default_config), opts or {})

    return config
end

function M.opts()
    return config
end

function M.win_opts()
    local opts = M.opts()

    local columns = vim.o.columns
    local lines = vim.o.lines

    local width = math.floor(columns * opts.width)
    local height = math.floor(lines * opts.height - 4)

    local row = (lines - height) / 2
    local col = (columns - width) / 2

    local win_opts = {
        relative = "editor",
        style = "minimal",
        border = opts.border,
        row = row,
        col = col,
        width = width,
        height = height,
    }

    return win_opts
end

return M

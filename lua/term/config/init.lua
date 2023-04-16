local Config = require("term.config.Config")

local M = {}

---@type Config
local config

---@class WindowConfig
---@field relative string
---@field style string
---@field row number
---@field col number
---@field width number
---@field height number
---@field border string|table
---@field zindex number

---setup configs
function M.setup(opts)
    config = Config.new(opts)

    return config
end

---get initialized configs
---@return Config
function M.config()
    return config
end

---get config for window
---@return WindowConfig
function M.panel_config()
    local columns = vim.o.columns
    local lines = vim.o.lines

    local skip_lines = vim.opt.cmdheight:get() + 3
    local width = math.floor(columns * config.width)
    local height = math.floor(config.height * (lines - skip_lines))

    local row = 0
    local col = 0

    if config.position == "center" then
        row = ((lines - skip_lines - height) / 2)
        col = (columns - width) / 2

        if row < 0 then
            row = 0
        end

        if col < 0 then
            col = 0
        end
    end

    local win_opts = {
        relative = "editor",
        style = "minimal",
        row = row,
        col = col,
        width = width,
        height = height,
        border = nil,
        zindex = 300,
    }

    return {
        win_opts = win_opts,
        border_opts = config.border,
        title_opts = config.title,
    }
end

---get config for window
function M.win_config()
    local opts = M.panel_config()
    local win_opts = opts.win_opts

    win_opts.width = win_opts.width - 2
    win_opts.height = win_opts.height - 2
    win_opts.row = win_opts.row + 1
    win_opts.col = win_opts.col + 1
    win_opts.zindex = 301

    return win_opts
end

return M

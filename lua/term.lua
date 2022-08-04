local Manager = require("term.Manager")
local config = require("term.config")
local colors = require("term.colors")

local M = {}

local manager = Manager.new()

local function setup_commands()
    vim.api.nvim_create_user_command("TermToggle", function()
        manager:toggle()
    end, {})
end

local function setup_colors()
    colors.set_hl("Term", { link = "Normal" })
end

function M.setup(opts)
    config.init(opts or {})
    setup_commands()
    setup_colors()
end

function M.status()
    return manager:status()
end

function M.toggle()
    manager:toggle()
end

function M.next()
    manager:next()
end

function M.prev()
    manager:prev()
end

return M

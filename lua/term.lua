local Manager = require("term.Manager")
local config = require("term.config")
local colors = require("term.colors")

local M = {}
local manager

---setup commands
local function setup_commands()
    vim.api.nvim_create_user_command("TermToggle", function()
        manager:toggle()
    end, {})
end

---setup highlights
local function setup_colors()
    colors.set_hl("Term", { link = "Normal" })
end

---setup plugin
---@param opts? Config
function M.setup(opts)
    manager = Manager.new()

    config.setup(opts or {})
    setup_commands()
    setup_colors()
end

---get terminals status
function M.status()
    return manager:status()
end

---toggle current terminal
function M.toggle()
    manager:toggle()
end

---go to next terminal
function M.next()
    manager:next()
end

---go to previous terminal
function M.prev()
    manager:prev()
end

---create a new terminal
function M.new()
    manager:new_terminal()
end

return M

local Manager = require("term.Manager")
local config = require("term.config")
local colors = require("term.colors")

local M = {}

local manager
manager = Manager.new()

local function setup_commands()
    vim.api.nvim_create_user_command("TermToggle", function()
        manager:toggle()
    end, {})
end

local function setup_colors()
    colors.set_hl("Term", { link = "Normal" })
    colors.set_hl("FloatBorder", { link = "Normal" })
end

function M.setup(opts)
    config.init(opts or {})
    setup_commands()
    setup_colors()

    vim.keymap.set({ "n", "t" }, "<C-\\>", function()
        manager:toggle()
    end)

    vim.keymap.set({ "t" }, "<C-n>", function()
        manager:next()
    end)

    vim.keymap.set({ "t" }, "<C-p>", function()
        manager:prev()
    end)

    vim.keymap.set({ "t" }, "<C-o>", function()
        manager:hide()

        local new_term = manager:new_terminal()
        manager:active(new_term)
    end)
end

function M.status()
    return manager:status()
end

return M

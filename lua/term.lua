local manager = require("term.manager")
local config = require("term.config")

local M = {}

local function setup_commands()
    vim.api.nvim_create_user_command("TermToggle", function()
        manager.toggle()
    end, {})
end

local function setup_autocmds()
    local group = vim.api.nvim_create_augroup("Term", { clear = true })

    vim.api.nvim_create_autocmd("TermOpen", {
        group = group,
        callback = function()
            vim.cmd("startinsert")
        end,
    })
end

function M.setup(opts)
    setup_commands()
    setup_autocmds()

    manager.init()

    config.init(opts or {})

    vim.keymap.set({ "n", "t" }, "<C-\\>", function()
        manager.toggle()
    end)

    vim.keymap.set({ "t" }, "<C-n>", function()
        manager.next()
    end)

    vim.keymap.set({ "t" }, "<C-p>", function()
        manager.prev()
    end)

    vim.keymap.set({ "t" }, "<C-o>", function()
        manager:hide()

        local new_term = manager.new_terminal()
        manager.set_current(new_term.id)
        manager:show()
    end)
end

return M

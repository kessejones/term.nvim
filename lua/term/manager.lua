local Terminal = require("term.Terminal")
local config = require("term.config")
local Window = require("term.ui.Window")

local Manager = {
    bg_bufnr = nil,
    bg_winid = nil,
    opened = false,
}

local terminals = {}
local current_id = nil

local _next_id = 1
local function get_next_id()
    local id = _next_id
    _next_id = _next_id + 1
    return id
end

local function find_next_terminal(cur)
    local id = cur + 1
    while id <= #terminals do
        if terminals[id] then
            return terminals[id]
        end
        id = id + 1
    end

    return nil
end

local function find_prev_terminal(cur)
    local id = cur - 1
    while id > 0 do
        if terminals[id] then
            return terminals[id]
        end
        id = id - 1
    end

    return nil
end

function Manager.setup()
    local win_opts = config.bg_win_opts()
    local bufnr = vim.api.nvim_create_buf(true, false)
    vim.bo[bufnr].buflisted = false

    Manager.bg_win = Window.new(bufnr, win_opts)
end

function Manager.current_terminal()
    return terminals[current_id]
end

function Manager.new_terminal()
    local id = get_next_id()

    local t = Terminal.new(id, config.opts())

    table.insert(terminals, id, t)

    Manager._set_autocmd(t.bufnr)

    return t
end

function Manager._set_autocmd(bufnr)
    vim.api.nvim_create_autocmd("BufEnter", {
        buffer = bufnr,
        callback = function()
            vim.cmd("startinsert")
        end,
    })
end

function Manager.remove_terminal(id)
    table.remove(terminals, id)
end

function Manager.set_current(id)
    current_id = id
end

function Manager.toggle()
    local terminal = Manager.current_terminal()

    if not terminal then
        terminal = Manager.new_terminal()
        Manager.set_current(terminal.id)
    end

    if Manager.bg_win.opened then
        Manager.hide()
    else
        Manager.show()
    end
end

function Manager.next()
    local next_terminal = find_next_terminal(current_id)
    if next_terminal then
        Manager.current_terminal():hide()

        Manager.set_current(next_terminal.id)
        next_terminal:show()
    end
end

function Manager.prev()
    local prev_terminal = find_prev_terminal(current_id)

    if prev_terminal then
        Manager.current_terminal():hide()

        Manager.set_current(prev_terminal.id)
        prev_terminal:show()
    end
end

function Manager.show()
    local cur = Manager.current_terminal()
    if cur then
        Manager._show_background()
        cur:show()
    end
end

function Manager.hide()
    local cur = Manager.current_terminal()
    if cur then
        Manager._hide_background()
        cur:hide()
    end
end

function Manager._show_background()
    Manager.bg_win:show(false)
    Manager.bg_win:set_option("winhl", "Normal:Term")
    Manager.bg_win:set_option("winhl", "Normal:TermBorder")
    Manager.bg_win:set_border()
end

function Manager._hide_background()
    Manager.bg_win:close()
end

function Manager.set_title()
    -- vim.api.nvim_buf_set_lines(M.bg_bufnr, 0, 1, false, { "Terminal 1/10" })
end

return Manager

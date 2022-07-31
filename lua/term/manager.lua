local Terminal = require("term.Terminal")
local config = require("term.config")

local M = {}

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

function M.current_terminal()
    return terminals[current_id]
end

function M.new_terminal()
    local id = get_next_id()
    local t = Terminal.new(id, config.opts())

    table.insert(terminals, id, t)

    return t
end

function M.remove_terminal(id)
    table.remove(terminals, id)
end

function M.set_current(id)
    current_id = id
end

function M.toggle()
    local terminal = M.current_terminal()

    if not terminal then
        terminal = M.new_terminal()
        M.set_current(terminal.id)
    end

    terminal:toggle()
end

function M.next()
    local next_terminal = find_next_terminal(current_id)
    if next_terminal then
        M.hide()

        M.set_current(next_terminal.id)
        M.show()
    end
end

function M.prev()
    local prev_terminal = find_prev_terminal(current_id)

    if prev_terminal then
        M.hide()

        M.set_current(prev_terminal.id)
        M.show()
    end
end

function M.show()
    local cur = M.current_terminal()
    cur:show()
end

function M.hide()
    local cur = M.current_terminal()
    cur:hide()
end

return M

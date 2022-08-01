local Terminal = require("term.Terminal")
local config = require("term.config")

local M = {
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

function M.init()
    -- vim.api.nvim_create_autocmd("TermPreOpen", {
    --     group = vim.api.nvim_create_augroup("TermCommands", {}),
    --     callback = function()
    --         vim.pretty_print("oal")
    --         M._show_background()
    --     end,
    -- })

    -- vim.api.nvim_create_autocmd("TermPreClose", {
    --     callback = function()
    --         M._show_background()
    --     end,
    -- })
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

    if terminal.window.opened then
        M.hide()
    else
        M.show()
    end
end

function M.next()
    local next_terminal = find_next_terminal(current_id)
    if next_terminal then
        M.current_terminal():hide()

        M.set_current(next_terminal.id)
        next_terminal:show()
    end
end

function M.prev()
    local prev_terminal = find_prev_terminal(current_id)

    if prev_terminal then
        M.current_terminal():hide()

        M.set_current(prev_terminal.id)
        prev_terminal:show()
    end
end

function M.show()
    local cur = M.current_terminal()
    if cur then
        cur:show()
    end
end

function M.hide()
    local cur = M.current_terminal()
    if cur then
        cur:hide()
    end
end

function M._show_background()
    -- local bufnr = vim.api.nvim_create_buf(false, false)
    -- vim.bo[bufnr].buflisted = false
    --
    -- local win_opts = config.win_opts()
    -- win_opts.focusable = false
    -- -- win_opts.border = "single"
    --
    -- M.bg_winid = vim.api.nvim_open_win(bufnr, false, win_opts)
    -- M.bg_bufnr = bufnr
    --
    -- M.set_title()
    -- M.opened = true
end

function M._hide_background()
    -- vim.api.nvim_win_close(M.bg_winid, true)
    --
    -- M.opened = false
end

function M.set_title()
    -- vim.api.nvim_buf_set_lines(M.bg_bufnr, 0, 1, false, { "Terminal 1/10" })
end

return M

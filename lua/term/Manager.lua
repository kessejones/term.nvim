local Terminal = require("term.Terminal")
local List = require("term.List")
local config = require("term.config")

---@class Manager
---@field terminals List
---@field current_index number
local Manager = {}

---create a new manager
---@return Manager
function Manager.new()
    local instance = {
        terminals = List.new(),
        current_index = 0,
    }

    setmetatable(instance, { __index = Manager })

    return instance
end

---get current terminal
---@return Terminal?
function Manager:current()
    return self.terminals:get(self.current_index)
end

---create a new terminal
---@return Terminal
function Manager:new_terminal()
    local opts = {
        shell = config.config().shell,
        on_exit = function(t)
            self:set_current(0)
            t:close()
            self.terminals:remove(t)
        end,
    }
    local terminal = Terminal.new(opts)
    self.terminals:push(terminal)

    return terminal
end

---remove terminal from index
---@param idx number
function Manager:remove_terminal(idx)
    self.terminals:delete(idx)
end

---set terminal index to current
---@param index number
function Manager:set_current(index)
    self.current_index = index
end

---toggle current terminal
function Manager:toggle()
    local terminal = self:current()

    if not terminal then
        terminal = self:new_terminal()
        self:set_current(0)
    end

    terminal:toggle()
end

---active a terminal
---@param t Terminal
function Manager:active(t)
    local index = self.terminals:index_of(t)

    self:set_current(index)
    self:show()
end

---show next terminal
function Manager:next()
    local next_term_idx = self.current_index + 1
    if next_term_idx > self.terminals:length() then
        return
    end

    local next_term = self.terminals:get(next_term_idx)
    if next_term then
        self:hide()
        self:set_current(next_term_idx)
        next_term:show()
    end
end

---show previous terminal
function Manager:prev()
    local prev_term_idx = self.current_index - 1
    if prev_term_idx < 0 then
        return
    end

    local prev_term = self.terminals:get(prev_term_idx)
    if prev_term then
        self:hide()

        self:set_current(prev_term_idx)
        prev_term:show()
    end
end

---show current terminal
function Manager:show()
    local cur = self:current()
    if cur then
        cur:show()
    end
end

---hide current terminal
function Manager:hide()
    local cur = self:current()
    if cur then
        cur:hide()
    end
end

---status of all terminals
---@return table
function Manager:status()
    return {
        current = (self.current_index or 0) + 1,
        count = self.terminals:length() or 0,
    }
end

return Manager

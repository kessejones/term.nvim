local Terminal = require("term.Terminal")
local List = require("term.List")
local Panel = require("term.ui.Panel")
local config = require("term.config")

---@class Manager
---@field terminals List
---@field current_index number
---@field panel Panel
local Manager = {}

---create a new manager
---@return Manager
function Manager.new()
    local instance = {
        terminals = List.new(),
        current_index = 0,
        panel = Panel.new(),
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
            t:close()
            self.terminals:remove(t)
            if self.terminals:length() > 0 then
                self:switch(0)
            else
                self.panel:close()
            end
            self:_update_title()
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

---update title of window
function Manager:_update_title()
    self.panel:set_title(string.format("Terminal %d/%d", self.current_index + 1, self.terminals:length()))
end

---set terminal index to current
---@param index number
function Manager:set_current(index)
    self.current_index = index

    self:_update_title()
end

---toggle current terminal
function Manager:toggle()
    local terminal = self:current()

    if not terminal then
        terminal = self:new_terminal()
        self:set_current(0)
    end

    self.panel:toggle()
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

    self:switch(next_term_idx)
end

---show previous terminal
function Manager:prev()
    local prev_term_idx = self.current_index - 1
    if prev_term_idx < 0 then
        return
    end
    self:switch(prev_term_idx)
end

---show current terminal
function Manager:show()
    local cur = self:current()
    if cur then
        self.panel:show()
        cur:show()
    end
end

---switch to terminal by id
function Manager:switch(to_idx)
    local to_open = self.terminals:get(to_idx)
    if to_open then
        local cur = self:current()
        if cur then
            cur:hide()
        end

        to_open:show()
        self:set_current(to_idx)
    end
end

---hide current terminal
function Manager:hide()
    local cur = self:current()
    if cur then
        self.panel:close()
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

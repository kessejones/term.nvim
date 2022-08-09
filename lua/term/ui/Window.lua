---@class Window
---@field bufnr number
---@field opts table
---@field winid number
---@field opened boolean
local Window = {}

---create new window
---@param bufnr number
---@param opts? table
---@return Window
function Window.new(bufnr, opts)
    local instance = {
        bufnr = bufnr,
        opts = opts or {},
        winid = nil,
        opened = false,
    }
    setmetatable(instance, { __index = Window })

    return instance
end

---set win opts
---@param opts table
function Window:set_opts(opts)
    self.opts = opts
end

---show window
---@param enter? boolean
function Window:show(enter)
    self.winid = vim.api.nvim_open_win(self.bufnr, enter or true, self.opts)
    self.opened = true
end

---close window
function Window:close()
    if self.winid then
        vim.api.nvim_win_close(self.winid, true)
    end
    self.opened = false
    self.winid = nil
end

---set option
---@param name string
---@param value string
function Window:set_option(name, value)
    vim.wo[self.winid][name] = value
end

---check if windows is opened
---@return boolean
function Window:is_opened()
    return self.opened
end

return Window

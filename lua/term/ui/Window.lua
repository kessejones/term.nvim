local Window = {}

function Window.new(bufnr, opts)
    local instance = {
        bufnr = bufnr,
        opts = opts,
        winid = nil,
        opened = false,
    }
    setmetatable(instance, { __index = Window })

    return instance
end

function Window:show()
    self.winid = vim.api.nvim_open_win(self.bufnr, true, self.opts)
    self.opened = true
end

function Window:close()
    vim.api.nvim_win_close(self.winid, true)
    self.opened = false
    self.winid = nil
end

function Window:set_option(name, value)
    vim.wo[self.winid][name] = value
end

return Window

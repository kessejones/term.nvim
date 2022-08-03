local Window = {}

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

function Window:set_opts(opts)
    self.opts = opts
end

function Window:show(enter)
    self.winid = vim.api.nvim_open_win(self.bufnr, enter or true, self.opts)
    self.opened = true
end

function Window:close()
    if self.winid then
        vim.api.nvim_win_close(self.winid, true)
    end
    self.opened = false
    self.winid = nil
end

function Window:set_option(name, value)
    vim.wo[self.winid][name] = value
end

function Window:is_opened()
    return self.opened
end

return Window

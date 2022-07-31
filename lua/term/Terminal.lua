local config = require("term.config")

local a = vim.api
local nvim_create_buf = vim.api.nvim_create_buf
local termopen = vim.fn.termopen

local Terminal = {}

function Terminal.new(id, opts)
    local instance = {
        id = id,
        channel = nil,
        bufnr = nil,
        opts = opts,
        started = false,
        opened = false,
    }

    setmetatable(instance, { __index = Terminal })

    return instance
end

function Terminal:toggle()
    if not self.opened then
        self:show()
    else
        self:hide()
    end
end

function Terminal:close()
    a.nvim_win_close(self.winid, true)
    a.nvim_buf_delete(self.bufnr)
end

function Terminal:show()
    self:_show()
    if self.started == false then
        self:_spawn()
    end

    self.opened = true

    vim.cmd("doautocmd TermOpen")
end

function Terminal:hide()
    if not self.winid then
        return
    end
    a.nvim_win_close(self.winid, true)
    self.opened = false
end

function Terminal:_spawn()
    self.channel = termopen(self.opts.shell or vim.o.shell, {
        on_exit = function()
            self:close()
        end,
    })

    self.started = true
end

function Terminal:_show()
    if not self.bufnr then
        self.bufnr = self:_create_buf()
    end

    local win_opts = config.win_opts()
    self.winid = a.nvim_open_win(self.bufnr, true, win_opts)
end

function Terminal:_create_buf()
    local bufnr = nvim_create_buf(true, false)
    vim.bo[bufnr].buflisted = false
    vim.bo[bufnr].filetype = "Term"

    return bufnr
end

return Terminal

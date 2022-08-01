local config = require("term.config")
local Window = require("term.ui.Window")

local a = vim.api
local nvim_create_buf = vim.api.nvim_create_buf
local termopen = vim.fn.termopen

local Terminal = {}

function Terminal.new(id, opts)
    local win_opts = config.win_opts()

    win_opts.row = win_opts.row + 1
    win_opts.col = win_opts.row + 1
    win_opts.height = win_opts.height - 2
    win_opts.width = win_opts.width - 2

    local bufnr = nvim_create_buf(true, false)
    local window = Window.new(bufnr, win_opts)

    vim.bo[bufnr].buflisted = false
    vim.bo[bufnr].filetype = "Term"

    local instance = {
        id = id,
        channel = nil,
        bufnr = nil,
        opts = opts,
        started = false,
        opened = false,
        window = window,
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
    self.window:close()
    a.nvim_buf_delete(self.bufnr)
end

function Terminal:show()
    self.window:show()
    self.window:set_option("winhl", "Normal:Term")

    if self.started == false then
        self:_spawn()
    end

    vim.cmd("doautocmd Term TermOpen")
end

function Terminal:hide()
    self.window:close()
end

function Terminal:_spawn()
    self.channel = termopen(self.opts.shell or vim.o.shell, {
        on_exit = function()
            self:close()
        end,
    })
    self.started = true
end

return Terminal

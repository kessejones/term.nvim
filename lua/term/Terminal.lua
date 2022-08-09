local config = require("term.config")
local Window = require("term.ui.Window")

local a = vim.api
local termopen = vim.fn.termopen

---@class Terminal
---@field channel number?
---@field opts table
---@field started boolean
---@field bufnr number
---@field window Window
local Terminal = {}

---create new bufnr
---@return number
local function create_buf()
    local bufnr = a.nvim_create_buf(false, true)

    vim.bo[bufnr].buflisted = false
    vim.bo[bufnr].filetype = "Term"

    return bufnr
end

---@param opts table
---@return Terminal
function Terminal.new(opts)
    local bufnr = create_buf()
    local window = Window.new(bufnr)

    local instance = {
        channel = nil,
        opts = opts,
        started = false,
        bufnr = bufnr,
        window = window,
    }

    setmetatable(instance, { __index = Terminal })

    return instance
end

---toggle terminal
function Terminal:toggle()
    if not self:is_opened() then
        self:show()
    else
        self:hide()
    end
end

---close terminal
function Terminal:close()
    self.window:close()
    a.nvim_buf_delete(self.bufnr, { force = true })
    vim.fn.jobstop(self.channel)

    self.bufnr = nil
end

---show terminal
function Terminal:show()
    local win_opts = config.win_config()
    self.window:set_opts(win_opts)

    self.window:show()
    self.window:set_option("winhl", "Normal:Term")

    if self.started == false then
        self:_spawn()
    end

    vim.cmd("startinsert")
end

function Terminal:hide()
    self.window:close()
end

---spawn terminal process
function Terminal:_spawn()
    local on_exit = self.opts.on_exit
    self.channel = termopen(self.opts.shell or vim.o.shell, {
        on_exit = function()
            if on_exit then
                on_exit(self)
            end
        end,
    })
    self.started = true
end

---checking if terminal is opened
---@return boolean
function Terminal:is_opened()
    return self.window:is_opened()
end

return Terminal

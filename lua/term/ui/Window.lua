local config = require("term.config")

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

function Window:show(enter)
    self.winid = vim.api.nvim_open_win(self.bufnr, enter or true, self.opts)
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

function Window:set_border()
    -- let [c_top, c_right, c_bottom, c_left, c_topleft, c_topright, c_botright, c_botleft] = borderchars
    -- let content = [c_topleft . title . repeat(c_top, repeat_width - title_width) . c_topright]
    -- let content += repeat([c_left . repeat(' ', repeat_width) . c_right], repeat_height)
    -- let content += [c_botleft . repeat(c_bottom, repeat_width) . c_botright]
    -- return floaterm#buffer#create_scratch_buf(content)

    local opts = config.bg_win_opts()
    local chars = config.opts().border_chars

    local lines = {}
    -- local top = chars[5] .. string.rep(" ", opts.width - 2) .. chars[6]
    local top = chars[5] .. string.rep(chars[1], opts.width - 2) .. chars[6]

    -- local middle = string.rep()
    table.insert(lines, top)

    vim.api.nvim_buf_set_lines(self.bufnr, 0, 1, false, lines)
end

return Window

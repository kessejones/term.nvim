local config = require("term.config")

local a = vim.api
local fmt = string.format

local function create_top_border(title, title_align, chars, width)
    local line = {}

    title = fmt(" %s ", title)
    if not title_align or title_align == "center" then
        if width % #title ~= 0 then
            title = fmt("%s ", title)
        end

        local width_part = (width / 2) - (#title / 2) - 1
        local top_left = chars[1] .. string.rep(chars[2], width_part)
        local top_center = title
        local top_right = string.rep(chars[2], width_part) .. chars[3]
        line = { top_left, top_center, top_right }
    elseif title_position == "left" then
        local top_left = chars[1] .. string.rep(chars[2], 5)
        local right_width = width - #title - 5 - 2
        local top_right = string.rep(chars[2], right_width) .. chars[3]
        line = { top_left, title, top_right }
    elseif title_position == "right" then
        local left_width = width - #title - 5 - 2
        local top_left = chars[1] .. string.rep(chars[2], left_width)
        local top_right = string.rep(chars[2], 5) .. chars[3]
        line = { top_left, title, top_right }
    end

    return table.concat(line)
end

local function create_middle_border(chars, width, height)
    local lines = {}
    local middle_width = width - 2
    for i = 1, height, 1 do
        local line = chars[1] .. string.rep(" ", middle_width) .. chars[2]
        table.insert(lines, line)
    end
    return lines
end

local function create_bottom_border(chars, width)
    return chars[1] .. string.rep(chars[2], width - 2) .. chars[3]
end

---@class Panel
---@field bufnr number
---@field title string
---@field win_opts table
---@field border_opts table
---@field title_opts table
---@field opened boolean
local Panel = {}

---create a new Panel
---@return Panel
function Panel.new()
    local buf = vim.api.nvim_create_buf(false, true)
    local instance = {
        bufnr = buf,
        title = "",
        win_opts = {},
        border_opts = {},
        title_opts = {},
        opened = false,
    }

    setmetatable(instance, { __index = Panel })

    return instance
end

--compou
function Panel:_compute_win_opts()
    local opts = config.panel_config()
    self.win_opts = opts.win_opts
    self.title_opts = opts.title_opts
    self.border_opts = opts.border_opts

    local chars = self.border_opts.chars
    local top_border_chars = { chars[1], chars[2], chars[3] }
    local width = self.win_opts.width
    local height = self.win_opts.height

    local border_top = create_top_border(self.title, self.title_opts.align, top_border_chars, width)
    local border_middle = create_middle_border({ chars[4], chars[8] }, width, height - 2)
    local border_bottom = create_bottom_border({ chars[7], chars[2], chars[5] }, width)

    local lines_border = border_middle
    table.insert(lines_border, 1, border_top)
    table.insert(lines_border, border_bottom)

    a.nvim_buf_set_lines(self.bufnr, 0, -1, false, lines_border)
    for i = 0, height, 1 do
        a.nvim_buf_add_highlight(self.bufnr, -1, self.border_opts.hl, i, 0, -1)
    end
end

function Panel:show()
    self:_compute_win_opts()
    self.winid = a.nvim_open_win(self.bufnr, false, self.win_opts)
    self.opened = true
end

function Panel:close()
    if self.winid then
        a.nvim_win_close(self.winid, true)
    end
    self.opened = false
    self.winid = nil
end

function Panel:toggle()
    if self.opened then
        self:close()
    else
        self:show()
    end
end

function Panel:_render_title()
    if self.opened then
        local chars = self.border_opts.chars
        local hl = self.border_opts.hl
        local top = create_top_border(
            self.title,
            self.title_opts.align,
            { chars[1], chars[2], chars[3] },
            self.win_opts.width
        )
        a.nvim_buf_set_lines(self.bufnr, 0, 1, false, { top })
        a.nvim_buf_add_highlight(self.bufnr, -1, hl, 0, 0, -1)
    end
end

function Panel:set_title(title)
    self.title = title

    self:_render_title()
end

return Panel

local Config = {}

local default_config = {
    shell = vim.o.shell,
    width = 0.5,
    height = 0.5,
    border_style = "rounded",
    border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    anchor = "NW",
    position = "center",
}

local config = nil

function Config.init(opts)
    config = vim.tbl_deep_extend("force", vim.deepcopy(default_config), opts or {})

    return config
end

function Config.opts()
    return config
end

function Config.win_opts()
    local opts = Config.opts()

    local columns = vim.o.columns
    local lines = vim.o.lines

    local skip_lines = vim.opt.cmdheight:get() + 3
    local width = math.floor(columns * opts.width)
    local height = math.floor(opts.height * (lines - skip_lines))

    local row = 0
    local col = 0

    if opts.position == "center" then
        row = ((lines - skip_lines - height) / 2)
        col = (columns - width) / 2

        if row < 0 then
            row = 0
        end

        if col < 0 then
            col = 0
        end
    end

    local border = opts.border_style
    if not opts.border_style then
        border = vim.tbl_map(function(b)
            return { b, "TermBorder" }
        end, opts.border)
    end

    local win_opts = {
        relative = "editor",
        style = "minimal",
        row = row,
        col = col,
        width = width,
        height = height,
        border = border,
        zindex = 300,
    }

    return win_opts
end

return Config

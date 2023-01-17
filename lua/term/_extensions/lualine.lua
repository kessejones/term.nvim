return {
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            function()
                local status = require("term").status()
                return string.format("%d/%d", status.current, status.count)
            end,
        },
    },
    filetypes = { "Term" },
}

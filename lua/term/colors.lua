local M = {}

local function convert_attributes(result, key, value)
    local target = result
    if key == "cterm" then
        result.cterm = {}
        target = result.cterm
    end
    if value:find(",") then
        for _, v in vim.split(value, ",") do
            target[v] = true
        end
    else
        target[value] = true
    end
end

local function convert_options(opts)
    local keys = {
        gui = true,
        guifg = "foreground",
        guibg = "background",
        guisp = "sp",
        cterm = "cterm",
        ctermfg = "ctermfg",
        ctermbg = "ctermbg",
        link = "link",
    }
    local result = {}
    for key, value in pairs(opts) do
        if keys[key] then
            if key == "gui" or key == "cterm" then
                if value ~= "NONE" then
                    convert_attributes(result, key, value)
                end
            else
                result[keys[key]] = value
            end
        end
    end
    return result
end

---set hightlight
---@param name string
---@param opts table
function M.set_hl(name, opts)
    vim.api.nvim_set_hl(0, name, convert_options(opts))
end

return M

local default_config = require("term.config.default")

---@alias BorderStyle nil | "none" | "single" | "corner" | "double" | "solid" | "rounded" | "shadow"
---@alias TitleAlign  "left" | "center" | "right"

---@class Border
---@field chars? table
---@field hl string

---@class Config
---@field shell string
---@field width number
---@field height number
---@field anchor string
---@field position string
---@field border Border
---@field title_align TitleAlign
local Config = {}

---setup config
---@param opts table
---@return Config
function Config.new(opts)
    local instance = vim.tbl_deep_extend("force", vim.deepcopy(default_config), opts or {})

    setmetatable(instance, { __index = Config })

    return instance
end

return Config

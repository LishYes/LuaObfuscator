local BasePass = require("base_pass")
local StringEncoderPass = setmetatable({}, {__index = BasePass})
StringEncoderPass.__index = StringEncoderPass

function StringEncoderPass.new()
    return setmetatable(BasePass.new(), StringEncoderPass)
end

function StringEncoderPass:visit_StringLiteral(node)
    local raw_str = string.sub(node.value, 2, -2)
    local max_len = #raw_str
    local escaped = ""
    for i = 1, max_len do
        local byte = string.byte(string.sub(raw_str, i, i))
        escaped = escaped .. string.format("\\%03d", byte)
    end
    node.value = '"' .. escaped .. '"'
    return node
end

return StringEncoderPass

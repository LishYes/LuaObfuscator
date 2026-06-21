local BasePass = {}
BasePass.__index = BasePass

function BasePass.new()
    return setmetatable({}, BasePass)
end

function BasePass:visit(node)
    if not node or type(node) ~= "table" then return node end
    local method = self["visit_" .. node.type]
    if method then
        return method(self, node)
    else
        return self:generic_visit(node)
    end
end

function BasePass:generic_visit(node)
    for k, v in pairs(node) do
        if type(v) == "table" then
            if v.type then
                node[k] = self:visit(v)
            else
                for i, child in ipairs(v) do
                    if type(child) == "table" and child.type then
                        v[i] = self:visit(child)
                    end
                end
            end
        end
    end
    return node
end

return BasePass

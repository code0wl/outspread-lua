-- move System
local Queue = class("Queue", System)

function Queue:requires() return {"energy"} end

function Queue:update(dt)
    for _, entity in pairs(self.targets) do
        local energy = entity:get("energy")

    end
end

return Queue

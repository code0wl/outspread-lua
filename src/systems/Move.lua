-- move System
local MoveSystem = class("MoveSystem", System)

function MoveSystem:requires() return {"position", "velocity"} end

function MoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local velocity = entity:get("velocity")
        position.x = position.x + velocity.speed * dt
        position.y = position.y + velocity.speed * dt
    end
end

return MoveSystem

-- other System

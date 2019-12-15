-- move System
local SpiderMoveSystem = class("SpiderMoveSystem", System)

function SpiderMoveSystem:requires() return {"position", "velocity"} end

function SpiderMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        print('called')
        local position = entity:get("position")
        local velocity = entity:get("velocity")
        position.x = position.x + velocity.speed * dt
        position.y = position.y + velocity.speed * dt
    end
end

return SpiderMoveSystem

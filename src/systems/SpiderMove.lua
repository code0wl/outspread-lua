-- move System
local SpiderMoveSystem = class("SpiderMoveSystem", System)

function SpiderMoveSystem:requires() return {"position", "velocity", "spider"} end

function SpiderMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local velocity = entity:get("velocity")

        position.x, position.y = util.setDirection(position.x, position.y,
                                                   velocity.speed,
                                                   entity.target, dt)

    end
end

return SpiderMoveSystem

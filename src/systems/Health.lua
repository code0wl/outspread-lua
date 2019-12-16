-- move System
local HealthSystem = class("HealthSystem", System)

function HealthSystem:requires() return {"health", "position"} end

function HealthSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local health = entity:get("health")
        local position = entity:get("position")

        health.amount = entity.health

        if health.amount < 1 then
            util.dropFoodOnMap(entity.type, position.x, position.y,
                               entity.width, entity.height, entity.angle,
                               health.deadInstance)
            engine:removeEntity(entity)
        end

    end
end

return HealthSystem

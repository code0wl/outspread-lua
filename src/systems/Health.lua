-- move System
local HealthSystem = class("HealthSystem", System)

function HealthSystem:requires() return {"health", "position"} end

function HealthSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local health = entity:get("health")
        local position = entity:get("position")
        local dimension = entity:get("dimension")

        if health.amount < 1 then
            print('died')
            util.dropFoodOnMap(entity.type, position.x, position.y,
                               dimension.width, dimension.height, entity.angle,
                               health.deadInstance)
            engine:removeEntity(entity)
        end

    end
end

return HealthSystem

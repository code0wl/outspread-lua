-- move System
local HealthSystem = class("HealthSystem", System)

function HealthSystem:requires() return {"health"} end

function HealthSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local health = entity:get("health")
        local dimension = entity:get("dimension")

        if health.amount < 1 then
            util.dropFoodOnMap(entity.type, entity.body:getX(),
                               entity.body:getY(), dimension.width,
                               dimension.height, entity.body:getAngle(),
                               health.deadInstance)
            engine:removeEntity(entity)
            entity = nil
            print(entity)
        end

    end
end

return HealthSystem

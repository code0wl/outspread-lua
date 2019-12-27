-- move System
local HealthSystem = class("HealthSystem", System)

function HealthSystem:requires() return {"health", "position", "food"} end

function HealthSystem:update()
    for _, entity in pairs(self.targets) do
        local health = entity:get("health")
        local food = entity:get("food")

        if health.amount < 1 then entity.dead = true end

        if food.amount < 0 then
            engine:removeEntity(entity)
            world:remove(entity)
        end

    end
end

return HealthSystem

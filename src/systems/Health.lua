-- move System
local HealthSystem = class("HealthSystem", System)

function HealthSystem:requires() return {"health", "position"} end

function HealthSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local health = entity:get("health")
        local position = entity:get("position")

        if health.amount < 1 then
            entity.isAlive = false
            util.dropFoodOnMap(self.type, position.x, position.y, self.width,
                               self.height, self.angle, health.graphic)
        end

    end
end

return HealthSystem

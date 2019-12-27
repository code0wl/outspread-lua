-- move System
local StatsSystem = class("StatsSystem", System)

function StatsSystem:requires() return {"stats", "energy", "position", "health"} end

function StatsSystem:draw()
    for _, entity in pairs(self.targets) do
        local energy = entity:get("energy")
        local position = entity:get("position")
        local health = entity:get("health")

        local spiderStats = {
            energy = energy.amount,
            health = health.amount,
            position = {x = position.x, y = position.y}
        }

        Lg.print("Spider stats : " .. tostring(inspect(spiderStats)),
                 position.x, position.y)
    end
end

return StatsSystem

-- move System
local StatsSystem = class("StatsSystem", System)

function StatsSystem:requires() return {"stats", "energy", "health"} end

function StatsSystem:draw()
    for _, entity in pairs(self.targets) do
        local energy = entity:get("energy")
        local signal = entity:get("signal")
        local health = entity:get("health")

        local spiderStats = {
            energy = energy.amount,
            health = health.amount,
            position = {x = entity.body:getX(), y = entity.body:getY()}
        }

        Lg.print("Spider stats : " .. tostring(inspect(spiderStats)),
                 entity.body:getX(), entity.body:getY())
    end
end

return StatsSystem

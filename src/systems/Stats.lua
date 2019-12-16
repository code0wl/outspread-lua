-- move System
local StatsSystem = class("StatsSystem", System)

function StatsSystem:requires() return {"stats", "energy", "position"} end

function StatsSystem:draw()
    for _, entity in pairs(self.targets) do
        local energy = entity:get("energy")
        local position = entity:get("position")
        local spiderStats = {energy = energy.amount, health = entity.health}

        Lg.print("Spider stats : " .. tostring(inspect(spiderStats)),
                 position.x, position.y)
    end
end

return StatsSystem

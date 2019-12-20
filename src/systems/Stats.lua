-- move System
local StatsSystem = class("StatsSystem", System)

function StatsSystem:requires() return {"stats", "energy", "position", "signal"} end

function StatsSystem:draw()
    for _, entity in pairs(self.targets) do
        local energy = entity:get("energy")
        local position = entity:get("position")
        local signal = entity:get("signal")
        local spiderStats = {energy = energy.amount, health = entity.health}

        if signal.aggressiveSignalActive then
            Lg.setColor(1, 1, 1)
            Lg.circle("fill", position.x, position.y,
                      signal.aggressionSignalSize)
        end

        if signal.foodSignalActive then
            Lg.setColor(1, 1, 1)
            Lg.circle("fill", position.x, position.y, signal.foodSignalSize)
        end

        Lg.print("Spider stats : " .. tostring(inspect(spiderStats)),
                 position.x, position.y)
    end
end

return StatsSystem

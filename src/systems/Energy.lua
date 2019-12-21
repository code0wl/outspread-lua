-- move System
local EnergySystem = class("EnergySystem", System)

function EnergySystem:requires() return {"energy"} end

function EnergySystem:update(dt)
    for _, entity in pairs(self.targets) do
        local energy = entity:get("energy")

        if energy.amount >= energy.maxEnergy then
            entity.target = Components.Position(util.travelRandomlyOffScreen())
        end

    end
end

return EnergySystem

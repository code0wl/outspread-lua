-- move System
local GameState = class("GameState", System)

function GameState:requires() return {"energy"} end

function GameState:update(dt)
    for _, entity in pairs(self.targets) do
        local energy = entity:get("energy")

        if energy.amount >= energy.maxEnergy then
            entity.target = Components.Position(util.travelRandomlyOffScreen())
        end

    end
end

return GameState

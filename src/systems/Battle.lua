-- Create a draw System.
local BattleSystem = class("BattleSystem", System)

function BattleSystem:requires()
    return {"position", "signal", "ant", "dimension"}
end

function BattleSystem:update()
    for _, entity in pairs(self.targets) do

        local position = entity:get('position')
        local signal = entity:get('signal')
        local dimension = entity:get('dimension')
        local ant = entity:get("ant")

    end
end

return BattleSystem

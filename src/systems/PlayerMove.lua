-- move System
local PlayerMoveSystem = class("PlayerMoveSystem", System)

function PlayerMoveSystem:requires() return {"player"} end

function PlayerMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        print(entity)
    end
end

return PlayerMoveSystem

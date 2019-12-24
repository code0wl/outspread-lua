-- move System
local CarrySystem = class("CarrySystem", System)

function CarrySystem:requires() return {"carry"} end

function CarrySystem:update(dt)
    for _, entity in pairs(self.targets) do
        local carry = entity:get('carry')

        if carry.actor then

            entity.target = entity.nest
        else
            entity.target = Components.Position(500, 500)
        end
    end
end

return CarrySystem

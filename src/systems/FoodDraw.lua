-- Create a draw System.
local FoodDrawSystem = class("FoodDrawSystem", System)

function FoodDrawSystem:requires() return {"position", "ant"} end

function FoodDrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local position = entity:get('position')
        local type = entity.type

        if entity.hasFood then
            if type == 2 then
                Lg.setColor(0, 0, 0)
            else
                Lg.setColor(1, 0, 0)
            end
            Lg.circle('fill', position.x, position.y, 4, 4)
            Lg.setColor(255, 255, 255)
        end
    end
end

return FoodDrawSystem

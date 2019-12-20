-- Create a draw System.
local FoodDrawSystem = class("FoodDrawSystem", System)

function FoodDrawSystem:requires() return {"position", "food", "scale"} end

function FoodDrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local scale = entity:get('scale')

        local position = entity:get("position")
        Lg.draw(entity.image, position.x, position.y, entity.angle,
                scale.amount, scale.amount)
    end
end

return FoodDrawSystem

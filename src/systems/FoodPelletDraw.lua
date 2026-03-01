-- Draws scattered food pellets as glowing diamond dots.
local FoodPelletDrawSystem = class("FoodPelletDrawSystem", System)

function FoodPelletDrawSystem:requires()
    return { "foodPellet", "position", "food" }
end

function FoodPelletDrawSystem:draw()
    Lg.setBlendMode("add")
    for _, entity in pairs(self.targets) do
        local pos    = entity:get("position")
        local pellet = entity:get("foodPellet")
        local food   = entity:get("food")
        if food.amount > 0 then
            local r, g, b = pellet.colour[1], pellet.colour[2], pellet.colour[3]
            local rad = pellet.radius

            -- soft outer glow
            Lg.setColor(r, g, b, 0.35)
            Lg.circle("fill", pos.x, pos.y, rad * 2.2)
            -- bright core
            Lg.setColor(1, 1, 1, 0.9)
            Lg.circle("fill", pos.x, pos.y, rad * 0.55)
            -- mid colour ring
            Lg.setColor(r, g, b, 0.85)
            Lg.circle("fill", pos.x, pos.y, rad)
        end
    end
    Lg.setBlendMode("alpha")
    Lg.setColor(1, 1, 1, 1)
end

return FoodPelletDrawSystem

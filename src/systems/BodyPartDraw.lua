-- Draws remaining spider body parts on the ground as brownish blobs.
local BodyPartDrawSystem = class("BodyPartDrawSystem", System)

function BodyPartDrawSystem:requires()
    return { "position", "bodyPart", "food" }
end

function BodyPartDrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local pos    = entity:get("position")
        local food   = entity:get("food")

        -- Scale visual with remaining food so it shrinks as ants carry pieces away
        local ratio  = math.max(0.1, food.amount / 30)
        local radius = (entity.radius or 6) * ratio

        local c      = entity.colour or { 0.55, 0.30, 0.10 }
        Lg.setColor(c[1], c[2], c[3], 0.85)
        Lg.circle("fill", pos.x, pos.y, radius)

        -- White outline so it stands out against the ground
        Lg.setColor(1, 1, 1, 0.4)
        Lg.circle("line", pos.x, pos.y, radius)

        Lg.setColor(1, 1, 1, 1)
    end
end

return BodyPartDrawSystem

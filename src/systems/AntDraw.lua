-- Create a draw System.
local AntDraySystem = class("AntDraySystem", System)

function AntDraySystem:requires() return {"position", "ant", "dimension"} end

function AntDraySystem:draw()
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local dimension = entity:get("dimension")

        entity.animation:draw(entity.image, position.x, position.y,
                              entity.angle, .4, .4,
                              util.getCenter(dimension.width),
                              util.getCenter(dimension.height))

        -- Attach food particle to ant once has food
        if entity.hasFood then
            Lg.setColor(255, 153, 153)
            Lg.circle("fill", position.x, position.y, 2)
        end

    end

end

return AntDraySystem

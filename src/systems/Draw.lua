-- Create a draw System.
local DrawSystem = class("DrawSystem", System)

function DrawSystem:requires() return {"position", "scale", "dimension"} end

function DrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local dimension = entity:get("dimension")
        local scale = entity:get("scale")

        if entity.animation then
            entity.animation:draw(entity.image, position.x, position.y,
                                  util.getAngle(entity.target.y, position.y,
                                                entity.target.x, position.x) -
                                      1.6 + math.pi, scale.amount, scale.amount,
                                  util.getCenter(dimension.width),
                                  util.getCenter(dimension.height))
        elseif entity.image then
            Lg.draw(entity.image, position.x, position.y, self.angle,
                    scale.amount, scale.amount)
        else
            Lg.draw(TerrainSprites.terrain, entity.graphic, position.x,
                    position.y, nil, scale.amount, scale.amount)
        end
    end

end

return DrawSystem

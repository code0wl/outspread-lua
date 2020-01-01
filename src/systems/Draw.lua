-- Create a draw System.
local DrawSystem = class("DrawSystem", System)

function DrawSystem:requires() return {"position", "dimension", "scale"} end

function DrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local dimension = entity:get("dimension")
        local scale = entity:get("scale")

        if entity.animation then
            entity.animation:draw(entity.image, position.x, position.y,
                                  util.getAngle(entity.target.y, position.y,
                                                entity.target.x, position.x),
                                  scale.amount, scale.amount,
                                  util.getCenter(dimension.width),
                                  util.getCenter(dimension.height))
        else
            --  refactor to draw other elements other than nest
            Lg.draw(TerrainSprites.terrain, entity.graphic, position.x,
                    position.y, nil, scale.amount, scale.amount)
        end
    end

end

return DrawSystem

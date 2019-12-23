-- Create a draw System.
local DrawSystem = class("DrawSystem", System)

function DrawSystem:requires() return {"scale", "dimension"} end

function DrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local dimension = entity:get("dimension")
        local scale = entity:get("scale")
        local position = entity:get('position')

        if entity.animation then
            entity.animation:draw(entity.image, entity.body:getX(),
                                  entity.body:getY(),
                                  util.getAngle(entity.target.y,
                                                entity.body:getY(),
                                                entity.target.x,
                                                entity.body:getX()) - PI,
                                  scale.amount, scale.amount,
                                  util.getCenter(dimension.width),
                                  util.getCenter(dimension.height))
        elseif entity.image then
            Lg.draw(entity.image, position.x, position.y, nil, scale.amount,
                    scale.amount)
        else
            Lg.draw(TerrainSprites.terrain, entity.graphic, position.x,
                    position.y, nil, scale.amount, scale.amount)
        end
    end

end

return DrawSystem

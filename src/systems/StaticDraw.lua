-- Create a draw System.
local StaticDrawSystem = class("StaticDrawSystem", System)

function StaticDrawSystem:requires() return {"nest"} end

function StaticDrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local scale = entity:get("scale")

        --  refactor to draw other elements other than nest
        Lg.draw(TerrainSprites.terrain, entity.graphic, position.x, position.y,
                nil, scale.amount, scale.amount)
    end

end

return StaticDrawSystem

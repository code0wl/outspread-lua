-- Create a draw System.
local SpiderDrawSystem = class("SpiderDrawSystem", System)

function SpiderDrawSystem:requires() return {"position", "spider"} end

function SpiderDrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")

        entity.animation:draw(entity.image, position.x, position.y,
                              util.getAngle(entity.target.y, position.y,
                                            entity.target.x, position.x) +
                                  math.pi, nil, nil,
                              util.getCenter(entity.width),
                              util.getCenter(entity.height))

    end

end

return SpiderDrawSystem

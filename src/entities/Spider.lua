local Actor = require("entities.Actor")
local Components = require("components.index")

local Spider = class("Spider", Actor)

function Spider:initialize(dimension)
    Actor.initialize(self)

    self.TimePassedSpider = 0
    self:add(Components.Spider(true))
    self:add(Components.Animation(true))

    local grid = anim8.newGrid(dimension.width, dimension.height, self.image:getWidth(), self.image:getHeight())

    self.animation = anim8.newAnimation(grid("1-5", 1, "1-5", 2), .04)
    engine:addEntity(self)
end

return Spider

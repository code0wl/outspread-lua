local Actor = require('entities.Actor')
local Components = require('components.index')

local Spider = class('Spider', Actor)

function Spider:initialize(dimension)
    Actor.initialize(self)

    self.TimePassedSpider = 0
    self.type = 3
    self:add(Components.Spider(true))
    self:add(Components.Animation(true))
    self.target = Components.Position(GlobalWidth / 2, GlobalHeight / 2)

    local grid = anim8.newGrid(dimension.width, dimension.height,
                               self.image:getWidth(), self.image:getHeight())

    self.animation = anim8.newAnimation(grid('1-5', 1, '1-5', 2), .04)
end

return Spider


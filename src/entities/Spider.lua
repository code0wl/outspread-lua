local Actor = require('entities.Actor')
local Components = require('components.index')

local Spider = class('Spider', Actor)

function Spider:initialize(spiderConfig)
    Actor.initialize(self)

    self.TimePassedSpider = 0
    self.type = 3
    self:add(Components.Spider(true))
    self:add(Components.Animation(true))
    self:add(Components.Position(spiderConfig.x, spiderConfig.y))
    self.target = Components.Position(spiderConfig.x, spiderConfig.y)
end

return Spider


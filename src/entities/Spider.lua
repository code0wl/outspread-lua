local Actor = require('entities.Actor')
local Components = require('components.index')

local Spider = class('Spider', Actor)

function Spider:initialize(spiderConfig)
    Actor.initialize(self)

    self.carryThreshold = 30
    self:add(Components.Position(spiderConfig.x, spiderConfig.y))
    self:add(Components.Spider(true))
    self:add(Components.Animation(true))
    self:add(Components.Stats(true))

    self.target = Components.Position(0, 0)

    -- Create timer component
    self.TimePassedSpider = 0

end

return Spider


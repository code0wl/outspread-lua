local Actor = require('entities.Actor')
local DeadSpider = require('entities.DeadSpider')
local Components = require('components.index')

local Spider = class('Spider', Actor)

function Spider:initialize(spiderConfig)
    Actor.initialize(self)

    self:add(Components.Position(spiderConfig.x, spiderConfig.y))
    self:add(Components.Spider(true))
    self:add(Components.Energy(100, 50))
    self:add(Components.Animation(true))
    self:add(Components.Health(100, DeadSpider))
    self:add(Components.Stats(true))
    self:add(Components.Signal(400, false, 500, false))

    self.target = Components.Position(0, 0)

    -- Create timer component
    self.TimePassedSpider = 0

end

return Spider


local Actor = require('entities.Actor')
local DeadSpider = require('entities.DeadSpider')
local Components = require('components.index')

local Spider = class('Spider', Actor)

function Spider:initialize(spiderConfig)
    Actor.initialize(self)

    self:add(Components.Spider(true))
    self:add(Components.Animation(true))
    self:add(Components.Health(100, DeadSpider))
    self:add(Components.Stats(true))

    self.target = Components.Position(0, 0)

    -- Create timer component
    self.TimePassedSpider = 0

    self.fixture:setUserData(self)

    self.body:setPosition(spiderConfig.x, spiderConfig.y)

end

return Spider


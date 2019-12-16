local Actor = require('entities.Actor')
local DeadSpider = require('entities.DeadSpider')
local Components = require('components.index')

local Spider = class('Spider', Actor)

function Spider:initialize()
    Actor.initialize(self)

    self:add(Components.Position(150, 25))
    self:add(Components.Velocity(80))
    self:add(Components.Spider(true))
    self:add(Components.Energy(100, 50))
    self:add(Components.Animation(true))
    self:add(Components.Health(100, DeadSpider))
    self:add(Components.Stats(true))

    self.target = {x = 0, y = 0}
    self.signal = util.signal(400, false, 500, false)
end

function Spider:hunt(animal)
    self.target = animal
    self:eat(animal, 10, 80)
end

return Spider


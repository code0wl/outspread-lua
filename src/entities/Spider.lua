local Actor = require('entities.Actor')
local DeadSpider = require('entities.DeadSpider')
local Components = require('components.index')

local Spider = class('Spider', Actor)

function Spider:initialize(spiderConfig)
    Actor.initialize(self)

    self:add(Components.Position(150, 25))
    self:add(Components.Velocity(80))
    self:add(Components.Spider(true))
    self:add(Components.Energy(100, 50))
    self:add(Components.Animation(true))
    self:add(Components.Health(10000, DeadSpider))

    self.speed = 80
    self.spiderConfig = spiderConfig
    self.target = {x = 0, y = 0}
    self.signal = util.signal(400, false, 500, false)
end

function Spider:hunt(animal)
    if self.energy < self.maxEnergy then
        self.speed = 500
        self.target = animal
        self:eat(animal, 10, 80)
    end
end

function Spider:update(dt)

    self.signal.aggressionSignalActive = false
    TimePassedAntSpider = TimePassedAntSpider + 1 * dt

end

return Spider


local Actor = require('entities.Actor')
local DeadSpider = require('entities.DeadSpider')
local Components = require('components.index')

local Spider = class('Spider', Actor)

function Spider:initialize(spiderConfig)
    Actor.initialize(self)

    self:add(Components.Position(150, 25))
    self:add(Components.Velocity(80))
    self:add(Components.Spider(true))

    self.speed = 80
    self.x, self.y = spiderConfig.x, spiderConfig.y
    self.maxEnergy = 100
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

    if self.health < 1 then
        self.isAlive = false
        util.dropFoodOnMap(self.type, self.x, self.y, self.width, self.height,
                           self.angle, DeadSpider)
    end

    self.signal.aggressionSignalActive = false
    TimePassedAntSpider = TimePassedAntSpider + 1 * dt

    self.animation:update(dt)

    if not self.signal.aggressionSignalActive and TimePassedAntSpider > 6 then
        self.energy = self.energy - .5
        TimePassedAntSpider = 0
        self.target = util.travelRandomly()
    end

    if self.energy >= self.maxEnergy then
        self.target = util.travelRandomlyOffScreen()
    end
end

return Spider


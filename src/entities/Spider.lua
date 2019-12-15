local Actor = require('entities.Actor')
local DeadSpider = require('entities.DeadSpider')

local Spider = class('Spider', Actor)

local spiderStats = {health = nil, energy = nil}

function Spider:initialize(spiderConfig)
    Actor.initialize(self)
    self.maxEnergy = 100
    self.spiderConfig = spiderConfig
    self.x, self.y = spiderConfig.x, spiderConfig.y
    self.target = {x = 0, y = 0}
    self.signal = util.signal(400, false, 500, false)
end

function Spider:draw()
    self.animation:draw(self.image, self.x, self.y,
                        util.getAngle(self.target.y, self.y, self.target.x,
                                      self.x) + math.pi, nil, nil,
                        util.getCenter(self.width), util.getCenter(self.height))

    Lg.print("Spider stats : " .. tostring(inspect(spiderStats)), self.x, self.y)
end

function Spider:hunt(animal)
    if self.energy < self.maxEnergy then
        self.speed = 500
        self.target = animal
        self:eat(animal, 10, 80)
    end
end

function Spider:update(dt)

    spiderStats = {energy = self.energy, health = self.health}

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

    self.x, self.y = util.setDirectionToTarget(self, dt)
end

return Spider


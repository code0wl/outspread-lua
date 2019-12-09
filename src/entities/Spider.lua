local Actor = require('entities.Actor')
local Spider = class('Spider', Actor)

function Spider:initialize(spiderConfig)
    Actor.initialize(self)
    
    self.spiderConfig = spiderConfig
    self.x, self.y =
        Component.position(self.spiderConfig.x, self.spiderConfig.y)
    self.target = {x = self.x, y = self.y}
end

function Spider:draw()
    self.animation:draw(self.image, self.x, self.y,
                        util.getAngle(self.target.y, self.y, self.target.x,
                                      self.x) + math.pi, nil, nil,
                        util.getCenter(self.width), util.getCenter(self.height))

end

function Spider:hunt(animal)
    if self.energy < self.maxEnergy then
        self.speed = 500
        self.target = animal
        self:eat(animal, 10, 80)
    end
end

function Spider:update(dt)

    if self.isAlive then
        if self.health < 1 then self.isAlive = false end

        self.signal.aggressionSignalActive = false
        TimePassedAntSpider = TimePassedAntSpider + 1 * dt

        self.animation:update(dt)

        if not self.signal.aggressionSignalActive and TimePassedAntSpider > 6 then
            self.energy = self.energy - .5
            TimePassedAntSpider = 0
            self.target.x, self.target.y =
                Component.position(math.random(GlobalWidth, 0),
                                   math.random(GlobalHeight, 0))
        end

        if self.energy >= self.maxEnergy then
            self.target = {x = -100, y = -100}
        end

        self.x, self.y = util.setDirectionToTarget(self, dt)

    end
end

return Spider


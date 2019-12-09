local Actor = require('entities.Actor')
local Spider = class('Spider', Actor)

function Spider:initialize(spiderConfig)
    self.type = spiderConfig.type

    self.image = Lg.newImage("images/spiders/spider" .. self.type ..
                                 "/spritesheets/sheet_spider_walk-small.png")

    self.x, self.y = Component.position(-100, 100)
    self.speed = 80
    self.maxEnergy = 1000
    self.energy = 10
    self.health = Component.health(10000)
    self.width = 180
    self.height = 150
    self.target = {x = -100, y = 100}
    self.isAlive = true

    -- Signal first draft
    self.signal = Component.signal(400, false, 500, false)

    self.grid = anim8.newGrid(self.width, self.height, self.image:getWidth(),
                              self.image:getHeight() + 1)

    self.animation = anim8.newAnimation(self.grid('1-5', 1, '1-5', 2), 0.04)

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


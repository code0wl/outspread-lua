local Spider = {}

function Spider:new(spiderConfig)
    local spider = setmetatable({}, {__index = Spider})

    spider.state = spiderConfig.state
    spider.type = spiderConfig.type

    spider.image = Lg.newImage("images/spiders/spider" .. spider.type ..
                                   "/spritesheets/sheet_spider_walk-small.png")

    spider.x, spider.y = Component.position(-100, 100)
    spider.speed = 70
    spider.health = Component.health(30)
    spider.width = 180
    spider.height = 150
    spider.target = {x = -100, y = 100}
    spider.alive = true

    -- Signal first draft
    spider.signal = Component.signal(400, false, 500, false)

    spider.grid = anim8.newGrid(spider.width, spider.height,
                                spider.image:getWidth(),
                                spider.image:getHeight() + 1)

    spider.animation = anim8.newAnimation(spider.grid('1-5', 1, '1-5', 2), 0.04)

    return spider
end

function Spider:draw()
    self.animation:draw(self.image, self.x, self.y,
                        util.getAngle(self.target.y, self.y, self.target.x,
                                      self.x) + math.pi, nil, nil,
                        util.getCenter(self.width), util.getCenter(self.height))

    if self.signal.aggressionSignalActive then
        Lg.setColor(1, 0, 0)
        Lg.circle('line', self.x, self.y, self.signal.aggressionSignalSize)
    end
end

function Spider:update(dt)
    self.signal.aggressionSignalActive = false
    TimePassedAntSpider = TimePassedAntSpider + 1 * dt

    self.animation:update(dt)

    if TimePassedAntSpider > 6 then
        TimePassedAntSpider = 0
        self.target.x, self.target.y = Component.position(
                                           math.random(GlobalWidth, 0),
                                           math.random(GlobalHeight, 0))
    end

    self.x, self.y = util.setDirectionToTarget(self, dt)

end

return Spider


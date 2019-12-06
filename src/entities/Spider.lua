local Spider = {}

function Spider:new(spiderConfig)
    local spider = setmetatable({}, {__index = Spider})

    spider.state = spiderConfig.state
    spider.type = spiderConfig.type

    spider.image = lg.newImage("images/spiders/spider" .. spider.type ..
                                   "/spritesheets/sheet_spider_walk-small.png")

    spider.x, spider.y = Component.position(-100, 100)
    spider.speed = 70
    spider.width = 180
    spider.height = 150
    spider.target = {x = -100, y = 100}
    spider.alive = true

    -- Signal first draft
    spider.signal = {
        foodRadius = 400,
        foodSignalActive = false,
        aggressionRadius = 500,
        aggressionSignalActive = false
    }

    -- Physics
    spider.body = lp.newBody(world, spider.x, spider.y, 'dynamic')
    spider.shape = lp.newRectangleShape(100, 80)
    spider.fixture = lp.newFixture(spider.body, spider.shape)

    spider.grid = anim8.newGrid(spider.width, spider.height,
                                spider.image:getWidth(),
                                spider.image:getHeight() + 1)

    spider.animation = anim8.newAnimation(spider.grid('1-5', 1, '1-5', 2), 0.04)

    return spider
end

function Spider:draw()
    self.animation:draw(self.image, self.body:getX(), self.body:getY(),
                        util.getAngle(self.target.y, self.body:getY(),
                                      self.target.x, self.body:getX()) + math.pi,
                        nil, nil, util.getCenter(self.width),
                        util.getCenter(self.height))

    lg.setColor(255, 153, 153)
    lg.rectangle("line", self.body:getX(), self.body:getY(), self.width / 2,
                 self.height / 2)

end

function Spider:update(dt)
    timePassedSpider = timePassedSpider + 1 * dt

    local spiderSpeed = self.speed * dt

    self.animation:update(dt)

    if timePassedSpider > 6 then

        timePassedSpider = 0

        self.target.x, self.target.y = Component.position(
                                           math.random(globalWidth, 0),
                                           math.random(globalHeight, 0))
    end

    util.setDirectionToTarget(spider, dt)

end

return Spider


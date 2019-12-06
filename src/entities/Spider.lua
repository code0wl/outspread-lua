local Spider = {}

function Spider(spiderConfig)
    local spider = {}
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

    -- Physics
    spider.body = lp.newBody(world, spider.x, spider.y, 'dynamic')
    spider.shape = lp.newRectangleShape(70, 50)
    spider.fixture = lp.newFixture(spider.body, spider.shape)

    spider.grid = anim8.newGrid(spider.width, spider.height,
                                spider.image:getWidth(),
                                spider.image:getHeight() + 1)

    spider.animation = anim8.newAnimation(spider.grid('1-5', 1, '1-5', 2), 0.04)

    function spider.update(dt)
        timePassedSpider = timePassedSpider + 1 * dt

        local spiderSpeed = spider.speed * dt
        spider.animation:update(dt)

        if timePassedSpider > 6 then

            timePassedSpider = 0

            spider.target.x, spider.target.y =
                Component.position(math.random(globalWidth, 0),
                                   math.random(globalHeight, 0))
        end

        util.setDirectionToTarget(spider, dt)

    end

    function spider.draw()
        spider.animation:draw(spider.image, spider.body:getX(),
                              spider.body:getY(),
                              util.getAngle(spider.target.y, spider.body:getY(),
                                            spider.target.x, spider.body:getX()) +
                                  math.pi, nil, nil,
                              util.getCenter(spider.width),
                              util.getCenter(spider.height))

        lg.setColor(255, 153, 153)
        lg.rectangle("line", spider.body:getX(), spider.body:getY(),
                     spider.width / 2, spider.height / 2)

    end

    return spider
end

return Spider


local Spider = {}

function Spider(spiderConfig)
    local spider = {}
    spider.state = spiderConfig.state
    spider.type = spiderConfig.type

    spider.images = {
        lg.newImage("images/spiders/spider" .. spider.type ..
                        "/spritesheets/sheet_spider_walk-small.png")
    }

    spider.x = -100
    spider.y = -100
    spider.hasFood = nil
    spider.currentState = spider.images[spider.state]
    spider.speed = 70
    spider.isSpider = true
    spider.width = 180
    spider.height = 150
    spider.target = nil
    spider.alive = true

    -- Physics
    spider.body = lp.newBody(world, spider.x, spider.y, 'dynamic')
    spider.shape = lp.newRectangleShape(70, 50)
    spider.fixture = lp.newFixture(spider.body, spider.shape)

    spider.grid = anim8.newGrid(spider.width, spider.height,
                                spider.currentState:getWidth(),
                                spider.currentState:getHeight() + 1)

    spider.animation = anim8.newAnimation(spider.grid('1-5', 1, '1-5', 2), 0.04)

    function spider.update(dt)
        timePassed = timePassed + 1 * dt

        local spiderSpeed = spider.speed * dt
        spider.animation:update(dt)

        if timePassed > 8 then

            timePassed = 0

            spider.target = {
                x = math.random(lg.getWidth(), 0),
                y = math.random(lg.getHeight(), 0)
            }
        elseif spider.target == nil then
            spider.target = spider
        end

        util.setDirectionToTarget(spider, dt)

    end

    function spider.draw()
        spider.animation:draw(spider.currentState, spider.body:getX(),
                              spider.body:getY(),
                              util.getAngle(spider.target.y, spider.body:getY(),
                                            spider.target.x, spider.body:getX()) +
                                  math.pi, nil, nil,
                              util.getCenter(spider.width),
                              util.getCenter(spider.height))

    end

    return spider
end

return Spider


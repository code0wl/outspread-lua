local Spider = {}

function Spider(antConfig)
    local spider = {}
    spider.state = antConfig.state
    spider.type = antConfig.type

    spider.images = {
        lg.newImage("images/spiders/spider" .. spider.type ..
                        "/spritesheets/sheet_spider_walk-small.png")
    }

    spider.x = math.random() * 2 * antConfig.x
    spider.y = math.random() * 2 * antConfig.y
    spider.hasFood = nil
    spider.currentState = spider.images[spider.state]
    spider.speed = 40
    spider.width = 180
    spider.height = 150
    spider.target = {x = 500, y = 500}
    spider.alive = true

    spider.grid = anim8.newGrid(spider.width, spider.height,
                                spider.currentState:getWidth(),
                                spider.currentState:getHeight() + 1)

    spider.animation = anim8.newAnimation(spider.grid('1-5', 1, '1-5', 2), 0.04)

    function spider.update(dt)
        local spiderSpeed = spider.speed * dt
        spider.animation:update(dt)

        spider.x = (spider.x -
                       math.cos(util.getAngle(spider.target.y, spider.x,
                                              spider.target.x, spider.x)) *
                       spiderSpeed)
        spider.y = (spider.y -
                       math.sin(util.getAngle(spider.target.y, spider.y,
                                              spider.target.x, spider.x)) *
                       spiderSpeed)

    end

    function spider.draw()
        spider.animation:draw(spider.currentState, spider.x, spider.y,
                              util.getAngle(spider.target.y, spider.y,
                                            spider.target.x, spider.x) + math.pi,
                              nil, nil, util.getCenter(spider.width),
                              util.getCenter(spider.height))

    end

    world:add(spider, spider.x, spider.y, spider.width, spider.height)

    return spider
end

return Spider


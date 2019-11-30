local Ant = {}

function Ant(antConfig)
    local ant = {}

    ant.state = antConfig.state
    ant.type = antConfig.type

    ant.images = {
        lg.newImage("images/ants/spritesheets/ant" .. ant.type ..
                        "/_ant_walk-small.png"),
        lg.newImage("images/ants/spritesheets/ant" .. ant.type ..
                        "/_ant_dead-small.png")
    }

    ant.x = antConfig.x
    ant.y = antConfig.y
    ant.hasFood = nil
    ant.currentState = ant.images[ant.state]
    ant.speed = 60
    ant.width = 16
    ant.height = 27
    ant.target = {}
    ant.alive = true

    -- Physics
    ant.body = lp.newBody(world, ant.x, ant.y)
    ant.shape = lp.newRectangleShape(ant.width, ant.height)
    ant.fixture = lp.newFixture(ant.body, ant.shape)

    ant.grid = anim8.newGrid(ant.width, ant.height, ant.currentState:getWidth(),
                             ant.currentState:getHeight() + 1)
    ant.animation = anim8.newAnimation(ant.grid('1-5', 1, '1-5', 2, '1-5', 3),
                                       0.04)

    function ant.update(dt) ant.animation:update(dt) end

    function ant.draw()
        ant.animation:draw(ant.currentState, ant.body:getX(), ant.body:getY(),
                           util.getAngle(ant.target.y, ant.body:getY(),
                                         ant.target.x, ant.body:getX()) + 1.6 +
                               math.pi, .5, .5, util.getCenter(ant.width),
                           util.getCenter(ant.height))

        if ant.hasFood then
            ant.speed = 40
            lg.setColor(255, 153, 153)
            lg.circle("fill", ant.body:getX(), ant.body:getY(), 2, 10)
        end

    end

    function ant.handleTarget(target, dt)
        if ant.hasFood then
            ant.target = target
        else
            ant.target = foodCollection.food[1]
        end

        for i, f in ipairs(foodCollection.food) do
            if util.distanceBetween(ant.body:getX(), ant.body:getY(), f.x, f.y) <
                20 then
                ant.hasFood = true
                f.amount = f.amount - 1
            end
        end

        util.setDirectionToTarget(ant, dt)

    end

    return ant

end

return Ant


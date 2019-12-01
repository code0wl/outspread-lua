local Ant = {}

function Ant(antConfig)
    local ant = {}

    ant.type = antConfig.type

    ant.image = lg.newImage("images/ants/spritesheets/ant" .. ant.type ..
                                "/_ant_walk-small.png")

    ant.x = antConfig.x
    ant.y = antConfig.y
    ant.nest = {x = antConfig.x, y = antConfig.y}
    ant.hasFood = nil
    ant.speed = 90
    ant.width = 16
    ant.height = 27
    ant.target = nil
    ant.isAlive = true

    -- Physics
    ant.body = lp.newBody(world, ant.x, ant.y, "dynamic")
    ant.shape = lp.newRectangleShape(4, 4)
    ant.fixture = lp.newFixture(ant.body, ant.shape, .5)
    ant.body:setSleepingAllowed(true)

    ant.grid = anim8.newGrid(ant.width, ant.height, ant.image:getWidth(),
                             ant.image:getHeight() + 1)
    ant.animation = anim8.newAnimation(ant.grid('1-5', 1, '1-5', 2, '1-5', 3),
                                       0.04)

    function ant.update(dt) ant.animation:update(dt) end

    function ant.draw()
        ant.animation:draw(ant.image, ant.body:getX(), ant.body:getY(),
                           util.getAngle(ant.target.y, ant.body:getY(),
                                         ant.target.x, ant.body:getX()) + 1.6 +
                               math.pi, .4, .4, util.getCenter(ant.width),
                           util.getCenter(ant.height))

        if ant.hasFood then
            ant.speed = 60
            lg.setColor(255, 153, 153)
            lg.circle("fill", ant.body:getX(), ant.body:getY(), 2)
        end

    end

    function ant.handleTarget(target, dt)

        timePassed = timePassed + 1 * dt

        if ant.hasFood or ant.target == nil then
            ant.target = ant.nest
        elseif timePassed > 3 then
            timePassed = 0
            ant.target = {
                x = math.random(globalWidth, 0),
                y = math.random(globalHeight, 0)
            }
        end

        for i, f in ipairs(foodCollection) do
            if f.amount > 0 then
                if util.distanceBetween(ant.body:getX(), ant.body:getY(), f.x,
                                        f.y) < 40 then
                    ant.hasFood = true
                    f.amount = f.amount - 1
                end
            end
        end

        if ant.hasFood then
            if util.distanceBetween(ant.body:getX(), ant.body:getY(), target.x,
                                    target.y) < 45 then
                ant.hasFood = false
                target.collectedFood = target.collectedFood + 1
            end
        end

        util.setDirectionToTarget(ant, dt)

    end

    return ant

end

return Ant


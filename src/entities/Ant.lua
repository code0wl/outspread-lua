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
    ant.scentLocation = nil

    -- Physics
    ant.body = lp.newBody(world, ant.x, ant.y, "dynamic")
    ant.shape = lp.newRectangleShape(4, 4)
    ant.fixture = lp.newFixture(ant.body, ant.shape, .5)
    ant.body:setSleepingAllowed(true)

    -- Signal first draft
    ant.signal = {radius = 100, active = false}

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

        if ant.signal.active then
            lg.circle('line', ant.body:getX(), ant.body:getY(),
                      ant.signal.radius)
        end

    end

    function ant.handleTarget(target, dt) setTargetForAnt(ant, target, dt) end

    return ant

end

function handleFood(ant)
    for i, f in ipairs(foodCollection) do
        if not ant.hasFood and
            util.distanceBetween(ant.body:getX(), ant.body:getY(), f.x, f.y) <
            f.amount then
            ant.hasFood = true
            ant.scentLocation = f
            ant.signal.active = true
            f.amount = f.amount - 1
        elseif ant.scentLocation and ant.scentLocation.amount < 1 then
            ant.scentLocation = nil
            ant.signal.active = false
        end
    end
end

function returnFoodToNest(ant, target)
    if ant.hasFood then
        if util.distanceBetween(ant.body:getX(), ant.body:getY(), ant.nest.x,
                                ant.nest.y) < 45 then
            ant.hasFood = false
            target.collectedFood = target.collectedFood + 1
        end
    end
end

function setTargetForAnt(ant, target, dt)
    timePassed = timePassed + 1 * dt

    if ant.hasFood then ant.target = ant.nest end

    -- Walk randomnly
    if timePassed > 2 or ant.target == nil then
        timePassed = 0
        ant.target = {
            x = math.random(globalWidth, 0),
            y = math.random(globalHeight, 0)
        }
    end

    -- Follow scent
    if not ant.hasFood and ant.scentLocation then
        ant.target = ant.scentLocation
    end

    -- Refactor me
    handleFood(ant)

    -- deliver food to nest
    returnFoodToNest(ant, target)

    util.setDirectionToTarget(ant, dt)
end

return Ant


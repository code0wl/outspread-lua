require("global")

local Colony = require("entities/Colony")
local Control = require("entities/Control")
local FoodCollection = require("entities/FoodCollection")

local foodCollection = FoodCollection({
    type = 1,
    x = 400,
    y = 300,
    amount = 10000
})

Colony({
    type = 1,
    x = 200,
    y = 600,
    population = 40
})

Colony({
    type = 2,
    x = 600,
    y = 600,
    population = 40
})

require("events")
local control = Control({ panspeed = 300 })

function love.load()
    background = love.graphics.newImage("images/background/background.png")
    background:setWrap("repeat", "repeat")
    bg_quad = lg.newQuad(0, 0, lg.getWidth(), lg.getHeight(), background:getWidth(), background:getHeight())
    cam:zoom(1)
end

function love.update(dt)
    world:update(dt)

    for _, colony in ipairs(Colony) do
        for _, ant in ipairs(colony.nest.ants) do
            ant:update(dt)

            if ant.hasFood then
                ant.target = colony.nest
            else
                ant.target = foodCollection.food[1]
            end

            for i, f in ipairs(foodCollection.food) do
                if util.distanceBetween(ant.body:getX(), ant.body:getY(), f.x, f.y) < 20 then
                    ant.hasFood = true
                    f.amount = f.amount - 1
                end
            end

            if util.distanceBetween(ant.body:getX(), ant.body:getY(), colony.nest.x, colony.nest.y) < 10 then
                ant.hasFood = false
                colony.nest.collectedFood = colony.nest.collectedFood + 1
            end

            ant.body:setX(ant.body:getX() - math.cos(util.getAngle(ant.target.y, ant.body:getX(), ant.target.x, ant.body:getX())) * ant.speed * dt)
            ant.body:setY(ant.body:getY() - math.sin(util.getAngle(ant.target.y, ant.body:getY(), ant.target.x, ant.body:getY())) * ant.speed * dt)
        end
    end

    if love.mouse.isDown(1) then
    end

    control:update(dt)
end

function love.draw()
    cam:attach()
    lg.draw(background, bg_quad, 0, 0)

    foodCollection:draw()

    -- draw ants
    for _, colony in ipairs(Colony) do
        colony.nest:draw()
        for _, ant in ipairs(colony.nest.ants) do
            ant:draw()
        end
    end

    cam:detach()

    lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

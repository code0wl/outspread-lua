require("global")

local Colony = require("entities/Colony")
local Control = require("entities/Control")
local FoodCollection = require("entities/FoodCollection")

local foodCollection = FoodCollection({
    type = 1,
    x = 400,
    y = 300,
    amount = 1000000
})

Colony({type = 1, x = 200, y = 600, population = 500})

require("events")
local control = Control({panspeed = 300})

function love.load()
    background = love.graphics.newImage("images/background/background.png")
    background:setWrap("repeat", "repeat")
    bg_quad = lg.newQuad(0, 0, lg.getWidth(), lg.getHeight(),
                         background:getWidth(), background:getHeight())
    cam:zoom(1)
end

function love.update(dt)
    world:update(dt)

    for _, colony in ipairs(Colony) do
        for _, ant in ipairs(colony.nest.ants) do
            ant.update(dt)

            if ant.hasFood then
                ant.target = colony.nest
            else
                ant.target = foodCollection.food[1]
            end

            for i, f in ipairs(foodCollection.food) do
                if util.distanceBetween(ant.x, ant.y, f.x, f.y) < 20 then
                    ant.hasFood = true
                    f.amount = f.amount - 1
                end
            end

            if util.distanceBetween(ant.x, ant.y, colony.nest.x, colony.nest.y) <
                10 then
                ant.hasFood = false
                colony.nest.collectedFood = colony.nest.collectedFood + 1
            end

            ant.x = (ant.x -
                        math.cos(util.getAngle(ant.target.y, ant.x,
                                               ant.target.x, ant.x)) * ant.speed *
                        dt)
            ant.y = (ant.y -
                        math.sin(util.getAngle(ant.target.y, ant.y,
                                               ant.target.x, ant.y)) * ant.speed *
                        dt)
        end
    end

    if love.mouse.isDown(1) then end

    control:update(dt)
end

function love.draw()
    cam:attach()
    lg.draw(background, bg_quad, 0, 0)

    foodCollection:draw()

    -- draw ants
    for _, colony in ipairs(Colony) do
        colony.nest:draw()
        for _, ant in ipairs(colony.nest.ants) do ant.draw() end
    end

    cam:detach()

    lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

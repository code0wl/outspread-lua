require("global")
Rock = require("entities/Rock")
require("entities/Colony")
local Control = require("entities/Control")
local FoodCollection = require("entities/FoodCollection")

local foodCollection = FoodCollection({
    type = 1,
    x = 400,
    y = 300,
    amount = 1000000
})


Colony({type = 1, x = 200, y = 600, population = 10000})

require("events")
local control = Control({panspeed = 300})

function love.load()
    background = love.graphics.newImage("images/background/background.png")
    background:setWrap("repeat", "repeat")
    bg_quad = lg.newQuad(0, 0, lg.getWidth(), lg.getHeight(),
                         background:getWidth(), background:getHeight())
    cam:zoom(1)

    rock = Rock({x = 300, y = 500, width = 100, height = 100})
end

function love.update(dt)

    for _, colony in ipairs(Colonies) do
        for _, ant in ipairs(colony.nest.ants) do
            ant.update(dt)
            local antSpeed = ant.speed * dt

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
                40 then
                ant.hasFood = false
                colony.nest.collectedFood = colony.nest.collectedFood + 1
            end

            ant.x = (ant.x -
                        math.cos(util.getAngle(ant.target.y, ant.x,
                                               ant.target.x, ant.x)) * antSpeed)
            ant.y = (ant.y -
                        math.sin(util.getAngle(ant.target.y, ant.y,
                                               ant.target.x, ant.x)) * antSpeed)
        end
    end

    if love.mouse.isDown(1) then end

    control.update(dt)
end

function love.draw()
    cam:attach()
    lg.draw(background, bg_quad, 0, 0)
    rock.draw()
    foodCollection.draw()

    -- draw ants
    for _, colony in ipairs(Colonies) do
        colony.nest.draw()
        for _, ant in ipairs(colony.nest.ants) do ant.draw() end
    end

    cam:detach()

    lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

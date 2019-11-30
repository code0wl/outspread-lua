require("global")
require("entities/Colony")

local Rock = require("entities/Rock")
local Control = require("entities/Control")
local Spider = require("entities/Spider")
local FoodCollection = require("entities/FoodCollection")

foodCollection = FoodCollection({
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

    rock = Rock({x = 300, y = 500, width = 100, height = 100})
    spider = Spider({type = 1, x = 600, y = 100, state = 1})

end

function love.update(dt)
    world:update(dt)
    spider.update(dt)

    for _, colony in ipairs(Colonies) do
        for _, ant in ipairs(colony.nest.ants) do
            ant.update(dt)
            ant.handleTarget(colony.nest, dt)
        end
    end

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

    spider.draw()

    cam:detach()

    lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

require("global")
require("events")

local Director = require("entities/Director")
local Rock = require("entities/Rock")
local Colony = require("entities/Colony")
local Control = require("entities/Control")
local Spider = require("entities/Spider")
local FoodCollection = require("entities/FoodCollection")

-- generate via tile object
foodCollection = FoodCollection({type = 1, x = 400, y = 300, amount = 1000000})

Colony({type = 1, x = 200, y = 600, population = 400})
Colony({type = 2, x = 1000, y = 200, population = 400})

local control = Control({panspeed = 300})

function love.load()
    background = love.graphics.newImage("images/background/background.png")

    background:setWrap("repeat", "repeat")
    bg_quad = lg.newQuad(0, 0, globalWidth, globalHeight, background:getWidth(),
                         background:getHeight())
    spider = Spider({type = 1, x = 600, y = 100, state = 1})

end

function love.update(dt)
    world:update(dt)
    spider.update(dt)

    for _, colony in ipairs(Colonies) do
        colony.nest.update(dt)
        for i, ant in ipairs(colony.nest.ants) do
            ant.update(dt)
            ant.handleTarget(colony.nest, dt)

            if Director.checkPreyCollision(ant, spider) then
                ant.isAlive = false
                table.remove(colony.nest.ants, i)
            end

        end
    end

    control.update(dt)
end

function love.draw()

    local mouseX, mouseY = lm.getPosition()
    local currentX, currentY = cam:getPosition()

    cam:draw(function(l, t, w, h)

        lg.draw(background, bg_quad, 0, 0)
        foodCollection.draw()

        -- draw ants
        for _, colony in ipairs(Colonies) do
            colony.nest.draw()
            for _, ant in ipairs(colony.nest.ants) do ant.draw() end
        end

        spider.draw()

        updateCameraLocation(mouseX, mouseY, currentX, currentY)

    end)

    lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)

    lg.print("Current black Pop : " ..
                 tostring(table.getn(Colonies[1].nest.ants)), 10, 40)

    lg.print(
        "Current red Pop : " .. tostring(table.getn(Colonies[2].nest.ants)), 10,
        70)

    love.graphics.print('Memory actually used (in kB): ' ..
                            collectgarbage('count'), 10, 100)

end

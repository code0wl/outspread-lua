require("global")
require("events")

local Director = require("entities/Director")
local Rock = require("entities/Rock")
local Colony = require("entities/Colony")
local Control = require("entities/Control")
local Spider = require("entities/Spider")
local Food = require("entities/Food")

foodCollection = {}

local control = Control({panspeed = 300})

function love.load()

    background = love.graphics.newImage("images/background/background.png")

    background:setWrap("repeat", "repeat")
    bg_quad = lg.newQuad(0, 0, globalWidth, globalHeight, background:getWidth(),
                         background:getHeight())
    spider = Spider({type = 1, x = 600, y = 100, state = 1})

    cam:setScale(1)

    level1 = sti("levels/level-1.lua")

    for i, obj in pairs(level1.layers["food"].objects) do Food(obj) end
    for i, obj in pairs(level1.layers["nest"].objects) do
        Colony({
            type = i,
            x = obj.x,
            y = obj.y,
            population = 100,
            width = obj.width,
            height = obj.height
        })
    end

end

function love.update(dt)
    world:update(dt)
    spider.update(dt)

    -- add daylight 
    local Lib = require("libs/light/light")

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

    light_world:begin()

    -- Camera
    cam:draw(function(l, t, w, h)

        lg.draw(background, bg_quad, 0, 0)

        -- draw ants
        for _, colony in ipairs(Colonies) do
            colony.nest.draw()
            for _, ant in ipairs(colony.nest.ants) do ant.draw() end
        end

        for _, food in ipairs(foodCollection) do food.draw() end

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

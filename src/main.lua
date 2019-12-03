require("global")
require("events")
require("component/main")
require("system/main")

local Rock = require("entities/Rock")
local Colony = require("entities/Colony")
local Control = require("entities/Control")
local Spider = require("entities/Spider")
local Food = require("entities/Food")

foodCollection = {}

local control = Control({panspeed = 300})

function love.load()

    gameWorld = initializeECSWorld()

    red = 26 / 255
    green = 154 / 255
    blue = 105 / 255

    love.graphics.setBackgroundColor(red, green, blue)

    spider = Spider({type = 1, x = 600, y = 100, state = 1})

    cam:setScale(1)

    level1 = sti("levels/level-1.lua")

    for i, obj in pairs(level1.layers["food"].objects) do Food(obj) end
    for i, obj in pairs(level1.layers["nest"].objects) do
        Colony({
            type = i,
            x = obj.x,
            y = obj.y,
            population = 10,
            width = obj.width,
            height = obj.height
        })
    end

end

function love.update(dt)

    gameWorld:update(dt)
    world:update(dt)
    spider.update(dt)

    for _, colony in ipairs(Colonies) do
        colony.nest.update(dt)

        -- ant locations 
        for i, ant in ipairs(colony.nest.ants) do
            ant.update(dt)
            ant.handleTarget(colony.nest, dt)

            if util.CheckCollisionWithPhysics(ant, spider) then
                -- ant.isAlive = false
            end

            if not ant.isAlive then table.remove(colony.nest.ants, i) end

            -- ant signals
            for j, a in ipairs(colony.nest.ants) do
                if a.signal.active and not ant.scentLocation then
                    if util.distanceBetween(a.body:getX(), a.body:getY(),
                                            ant.body:getX(), ant.body:getY()) <
                        a.signal.radius then
                        ant.scentLocation = a.scentLocation
                    end
                end
            end

        end

    end

    control.update(dt)
end

function love.draw()
    local mouseX, mouseY = lm.getPosition()
    local currentX, currentY = cam:getPosition()

    -- Camera
    cam:draw(function(l, t, w, h)

        -- draw ants
        for _, colony in ipairs(Colonies) do
            colony.nest.draw()
            for _, ant in ipairs(colony.nest.ants) do ant.draw() end
        end

        for i, food in ipairs(foodCollection) do
            if (food.amount < 1) then table.remove(foodCollection, i) end
            food.draw()
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

-- Initialize the ECS world
function initializeECSWorld() return tiny.world(System.movement) end

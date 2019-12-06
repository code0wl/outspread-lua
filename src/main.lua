require("global")
require("Mouse")
require("Debug")

Component = require("component/main")

local Rock = require("entities/Rock")
local Colony = require("entities/Colony")
local Control = require("Control")
local Spider = require("entities/Spider")
local Food = require("entities/Food")
Player = require("entities/Player")

local Colonies = {}
local foodCollection = {}

function love.load()
    red = 26 / 255
    green = 154 / 255
    blue = 105 / 255

    lg.setBackgroundColor(red, green, blue)

    spider = Spider:new({type = 1, x = 600, y = 100, state = 1})

    cam:setScale(1)

    level1 = sti("levels/level-1.lua")

    for i, obj in pairs(level1.layers["food"].objects) do
        table.insert(foodCollection, Food:new(obj))
    end
    for i, obj in pairs(level1.layers["nest"].objects) do
        table.insert(Colonies, Colony:new(
                         {
                type = i,
                x = obj.x,
                y = obj.y,
                population = 500,
                width = obj.width,
                height = obj.height
            }))

    end
end

function love.update(dt)

    world:update(dt)
    spider:update(dt)
    Control.update(dt)
    Player:update()

    for _, colony in ipairs(Colonies) do
        colony.nest:update(dt)

        -- ant locations 
        for i, ant in ipairs(colony.nest.ants) do
            ant:update(foodCollection, colony.nest, dt, spider)

            if not ant.isAlive then table.remove(colony.nest.ants, i) end

            -- ant signals (move to director)
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
end

function love.draw()
    local mouseX, mouseY = lm.getPosition()
    local currentX, currentY = cam:getPosition()

    -- Camera
    cam:draw(function(l, t, w, h)

        for i, phermone in ipairs(Player.phermones) do
            lg.setColor(255, 153, 153)
            lg.circle('line', phermone.x, phermone.y, 5)
        end

        -- draw ants
        for _, colony in ipairs(Colonies) do
            colony.nest:draw()
            for _, ant in ipairs(colony.nest.ants) do ant:draw() end
        end

        spider:draw()

        for i, food in ipairs(foodCollection) do
            if (food.amount < 1) then table.remove(foodCollection, i) end
            food:draw()
        end

        updateCameraLocation(mouseX, mouseY, currentX, currentY)

    end)

    printDetailsToScreen(Colonies)

end


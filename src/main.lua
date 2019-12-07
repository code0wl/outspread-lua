require("Global")
require("Mouse")
require("Debug")

Component = require("component.main")

local Colony = require("entities.Colony")
local Control = require("Control")
local Spider = require("entities.Spider")
local Food = require("entities.Food")
Player = require("entities.Player")

local spider = Spider:new({type = 1, x = 600, y = 100, state = 1})

function love.load()
    local red = 26 / 255
    local green = 154 / 255
    local blue = 105 / 255

    Lg.setBackgroundColor(red, green, blue)

    cam:setScale(1)

    local level1 = sti("levels/level-1.lua")

    for _, obj in pairs(level1.layers["food"].objects) do
        table.insert(FoodCollection, Food:new(obj))
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
            ant:update(FoodCollection, colony.nest, dt, spider)

            if not ant.isAlive then table.remove(colony.nest.ants, i) end

            -- handle spider ant interaction
            if not spider.signal.aggressionSignalActive and
                util.distanceBetween(ant.body:getX(), ant.body:getY(),
                                     spider.body:getX(), spider.body:getY()) <
                spider.signal.aggressionSignalSize then
                spider.signal.aggressionSignalActive = true
            else
                spider.signal.aggressionSignalActive = false
            end

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

        for _, phermone in ipairs(Player.phermones) do
            Lg.setColor(255, 153, 153)
            Lg.circle('line', phermone.x, phermone.y, 5)
        end

        -- draw ants
        for _, colony in ipairs(Colonies) do
            colony.nest:draw()
            for _, ant in ipairs(colony.nest.ants) do ant:draw() end
        end

        spider:draw()

        for i, food in ipairs(FoodCollection) do
            if (food.amount < 1) then table.remove(FoodCollection, i) end
            food:draw()
        end

        updateCameraLocation(mouseX, mouseY, currentX, currentY)

    end)

    printDetailsToScreen(Colonies)

end


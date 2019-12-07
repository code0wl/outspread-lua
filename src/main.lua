require("Global")
require("Mouse")
require("Debug")

Component = require("component.main")

local Colony = require("entities.Colony")
local Control = require("Control")
local Spider = require("entities.Spider")
local Food = require("entities.Food")
Player = require("entities.Player")

function love.load()
    local red = 26 / 255
    local green = 154 / 255
    local blue = 105 / 255

    Lg.setBackgroundColor(red, green, blue)

    Cam:setScale(1)

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
                population = 1000,
                width = obj.width,
                height = obj.height
            }))
    end

    -- insert other WildLife
    table.insert(WildLife, Spider:new({type = 1, x = 600, y = 100, state = 1}))
    table.insert(WildLife, Spider:new({type = 1, x = 600, y = 100, state = 1}))

end

function love.update(dt)

    Player:update()

    Control.update(dt)

    for lifeIndex, life in ipairs(WildLife) do
        life:update(dt)
        -- if not life.isAlive then  end
    end

    for _, colony in ipairs(Colonies) do
        colony.nest:update(dt)

        -- ant locations 
        for i, ant in ipairs(colony.nest.ants) do
            ant:update(FoodCollection, colony.nest, dt)

            if not ant.isAlive then table.remove(colony.nest.ants, i) end

            -- handle life ant interaction
            for _, life in ipairs(WildLife) do

                -- if scent is life
                -- to avoid repeated lookups
                local lifeX = life.x
                local lifeY = life.y
                if not ant.hasFood and
                    util.distanceBetween(ant.x, ant.y, lifeX, lifeY) <
                    ant.signal.aggressionSignalSize then
                    ant.target = {x = lifeX, y = lifeY}
                    ant.signal.aggressionSignalActive = true
                else
                    ant.signal.aggressionSignalActive = false
                end

                if life.signal and not life.signal.aggressionSignalActive and
                    util.distanceBetween(ant.x, ant.y, lifeX, lifeY) <
                    life.signal.aggressionSignalSize then
                    life.signal.aggressionSignalActive = true
                    life:hunt(ant)
                end

                if ant.signal.aggressionSignalActive and
                    util.distanceBetween(ant.x, ant.y, lifeX, lifeY) <
                    life.width then
                    ant:attack(life)
                    if not life.isAlive then
                        table.insert(FoodCollection, Food:new(
                                         {x = lifeX, y = lifeY, amount = 100}))
                        table.remove(WildLife, _)
                    end
                end
            end

            -- Relay information about food to other ants in the same colony
            for j, a in ipairs(colony.nest.ants) do
                if a.signal.active and not ant.scentLocation and
                    util.distanceBetween(a.x, a.y, ant.x, ant.y) <
                    a.signal.radius then
                    ant.scentLocation = a.scentLocation
                end
            end

        end
    end
end

function love.draw()
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

    -- Camera
    Cam:draw(function(l, t, w, h)

        for i, food in ipairs(FoodCollection) do
            if (food.amount < 1) then table.remove(FoodCollection, i) end
            food:draw()
        end

        -- draw ants
        for _, colony in ipairs(Colonies) do
            colony.nest:draw()
            for _, ant in ipairs(colony.nest.ants) do ant:draw() end
        end

        -- draw other animals
        for _, life in ipairs(WildLife) do life:draw() end

        for _, phermone in ipairs(Player.phermones) do
            Lg.setColor(255, 153, 153)
            Lg.circle('line', phermone.x, phermone.y, 5)
        end

        updateCameraLocation(mouseX, mouseY, currentX, currentY)

    end)

    printDetailsToScreen(Colonies)

end


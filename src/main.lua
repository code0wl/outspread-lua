require("Global")
require("Mouse")
require("Debug")

local Colony = require("entities.Colony")
local Control = require("Control")
local Spider = require("entities.Spider")
local Food = require("entities.Food")

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
                population = 900,
                width = obj.width,
                height = obj.height
            }))
    end

    -- insert other WildLife
    table.insert(WildLife, Spider:new({type = 1, x = 600, y = 100, state = 1}))

end

function love.update(dt)

    local antLocations = {{}, {}}

    Player:update()

    Control.update(dt)

    for _, life in ipairs(WildLife) do life:update(dt) end

    for colonyIndex, colony in ipairs(Colonies) do
        colony.nest:update(dt)

        -- ant locations 
        for i, ant in ipairs(colony.nest.ants) do

            table.insert(antLocations[colonyIndex], ant)

            if not ant.isAlive then table.remove(colony.nest.ants, i) end

            ant:update(FoodCollection, colony.nest, dt)

            -- handle otherCreature with ant interaction
            for otherCreatureIndex, otherCreature in ipairs(WildLife) do

                -- if scent is otherCreature
                local otherCreatureX, otherCreatureY = otherCreature.x,
                                                       otherCreature.y
                local antX, antY = ant.x, ant.y
                if not ant.hasFood and
                    util.distanceBetween(antX, antY, otherCreatureX,
                                         otherCreatureY) <
                    ant.signal.aggressionSignalSize then
                    ant.target = {x = otherCreatureX, y = otherCreatureY}
                    ant.signal.aggressionSignalActive = true
                else
                    ant.signal.aggressionSignalActive = false
                end

                -- animal attack and hunt ant
                if otherCreature.signal and
                    not otherCreature.signal.aggressionSignalActive and
                    util.distanceBetween(antX, antY, otherCreatureX,
                                         otherCreatureY) <
                    otherCreature.signal.aggressionSignalSize then
                    otherCreature.signal.aggressionSignalActive = true
                    otherCreature:hunt(ant)
                end

                -- ant attack other animals
                if ant.signal.aggressionSignalActive and
                    util.distanceBetween(antX, antY, otherCreatureX,
                                         otherCreatureY) < otherCreature.width then
                    ant:attack(otherCreature)
                    if not otherCreature.isAlive then
                        table.insert(FoodCollection, Food:new(
                                         {
                                x = otherCreatureX,
                                y = otherCreatureY,
                                amount = 100
                            }))
                        table.remove(WildLife, otherCreatureIndex)
                    end
                end

            end

            for j, a in ipairs(colony.nest.ants) do
                -- Relay information about food to other ants in the same colony
                if a.signal.foodSignalActive and not ant.scentLocation and
                    util.distanceBetween(a.x, a.y, ant.x, ant.y) <
                    a.signal.foodSignalSize then
                    ant.scentLocation = a.scentLocation
                end
            end

        end

    end

    -- detect if rival ants are fighting
    -- refactor
    for _, blackAnt in ipairs(antLocations[1]) do
        for _, redAnt in ipairs(antLocations[2]) do
            if util.distanceBetween(blackAnt.x, blackAnt.y, redAnt.x, redAnt.y) <
                blackAnt.signal.aggressionSignalSize then

                blackAnt.target = {x = redAnt.x, y = redAnt.y}
                redAnt.target = {x = blackAnt.x, y = blackAnt.y}
            end

            if util.distanceBetween(blackAnt.x, blackAnt.y, redAnt.x, redAnt.y) <
                30 then
                blackAnt:attack(redAnt)
                redAnt:attack(blackAnt)
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


require("Global")
require("Mouse")
require("Debug")

local asset = require("Assets")
local OutSpreadEngine = require("OutSpreadEngine")

local Control = require("Control")

local bg_image = Lg.newImage("/images/background/background.png")

bg_image:setWrap("repeat", "repeat")

-- note how the Quad's width and height are larger than the image width and height.
QuadBQ = Lg.newQuad(0, 0, GlobalWidth, GlobalHeight, bg_image:getWidth(),
                    bg_image:getHeight())

function love.load()
    asset.generateWorldAssets()
    OutSpreadEngine.addSystems()
end

function love.update(dt)

    engine:update(dt)

    local antLocations = {{}, {}}

    local colonySwap = {2, 1}

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

            -- Relay information about food to other ants in the same colony
            for j, a in ipairs(antLocations[colonyIndex]) do
                if a.signal.foodSignalActive and
                    util.distanceBetween(a.x, a.y, ant.x, ant.y) <
                    a.signal.foodSignalSize then
                    ant.scentLocation = a.scentLocation
                end
            end

            -- refactor to make use of own class
            -- Logic for other ants
            for _, otherAnt in ipairs(antLocations[colonySwap[colonyIndex]]) do

                local isClose = util.distanceBetween(ant.x, ant.y, otherAnt.x,
                                                     otherAnt.y)

                if isClose < ant.signal.aggressionSignalSize then

                    ant:handleAggressor(otherAnt)
                    ant:dropFood()

                    otherAnt:handleAggressor(ant)
                    otherAnt:dropFood()

                    ant:fightMode(true)
                    otherAnt:fightMode(true)

                    if isClose < ant.height then
                        ant:attack(otherAnt)
                        otherAnt:attack(ant)
                    end

                else
                    ant:fightMode(false)
                    otherAnt:fightMode(false)
                end

            end

            -- handle otherCreature with ant interaction
            for otherCreatureIndex, otherCreature in ipairs(WildLife) do

                -- if scent is otherCreature
                ant:handleAggressor(otherCreature)

                -- animal attack and hunt ant
                if otherCreature.signal and
                    not otherCreature.signal.aggressionSignalActive and
                    util.distanceBetween(ant.x, ant.y, otherCreature.x,
                                         otherCreature.y) <
                    otherCreature.signal.aggressionSignalSize then
                    otherCreature.signal.aggressionSignalActive = true
                    otherCreature:hunt(ant)
                end

                if not otherCreature.isAlive then
                    table.remove(WildLife, otherCreatureIndex)
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

        Lg.draw(bg_image, QuadBQ, 0, 0)

        for i, food in ipairs(FoodCollection) do
            if (food.amount < 1) then table.remove(FoodCollection, i) end
            food:draw()
        end

        -- draw ants
        for _, colony in ipairs(Colonies) do
            colony.nest:draw()

            for _, ant in ipairs(colony.nest.ants) do ant:draw() end
        end

        -- Draw player phermones
        for _, phermone in ipairs(Player.phermones) do
            Lg.setColor(255, 153, 153)
            Lg.circle('fill', phermone.x, phermone.y, 5)
        end

        engine:draw()

        UpdateCameraLocation(mouseX, mouseY, currentX, currentY)

    end)

    PrintDetailsToScreen(Colonies)

end


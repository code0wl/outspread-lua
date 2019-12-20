require("Global")
require("Mouse")
require("Debug")
require("PrepareImages")

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
    local Colonies = engine:getEntitiesWithComponent("colony")

    engine:update(dt)
    local antLocations = {{}, {}}
    local colonySwap = {2, 1}
    Player:update()
    Control.update(dt)

    for colonyIndex, colony in ipairs(Colonies) do
        colony.nest:update(dt)

        -- ant locations 
        for i, ant in ipairs(colony.nest.ants) do

            table.insert(antLocations[colonyIndex], ant)

            ant:update(engine:getEntitiesWithComponent("food"), colony.nest, dt)

            -- Relay information about food to other ants in the same colony
            for j, a in ipairs(antLocations[colonyIndex]) do
                if a:get("signal").foodSignalActive and
                    util.distanceBetween(a.x, a.y, ant.x, ant.y) <
                    a:get("signal").foodSignalSize then
                    ant.scentLocation = a.scentLocation
                end
            end

            -- refactor to make use of own class
            -- Logic for other ants
            for _, otherAnt in ipairs(antLocations[colonySwap[colonyIndex]]) do

                local isClose = util.distanceBetween(ant.x, ant.y, otherAnt.x,
                                                     otherAnt.y)

                if isClose < ant:get("signal").aggressionSignalSize then

                    ant:handleAggressor(otherAnt)

                    otherAnt:handleAggressor(ant)

                    ant:fightMode(true)
                    otherAnt:fightMode(true)

                    if isClose < ant:get("dimension").height then
                        ant:attack(otherAnt)
                        otherAnt:attack(ant)
                    end

                else
                    ant:fightMode(false)
                    otherAnt:fightMode(false)
                end

            end

            -- handle otherCreature with ant interaction
            for _, otherCreature in ipairs(
                                        engine:getEntitiesWithComponent("spider")) do

                local x, y = otherCreature:get("position").x,
                             otherCreature:get("position").y

                -- if scent is otherCreature
                ant:handleAggressor(otherCreature)

                -- animal attack and hunt ant
                if otherCreature:get("signal") and
                    not otherCreature:get("signal").aggressionSignalActive and
                    util.distanceBetween(ant.x, ant.y, x, y) <
                    otherCreature:get("signal").aggressionSignalSize then
                    otherCreature:get("signal").aggressionSignalActive = true
                    otherCreature:hunt(ant)
                end

            end

        end

    end

end

function love.draw()
    local Colonies = engine:getEntitiesWithComponent("colony")
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

    -- Camera
    Cam:draw(function(l, t, w, h)

        Lg.draw(bg_image, QuadBQ, 0, 0)

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


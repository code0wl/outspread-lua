local WorldMap = class("WorldMap")
local Levels = require "Levels"
local Colony = require("entities.Colony")

function WorldMap:create(level)
    Colony:new(
        {
            type = level.colony.type,
            x = level.location.x,
            y = level.location.y,
            population = level.colony.population,
            width = level.width,
            height = level.height
        }
    )

    if level.rivals then
        local rival = level.rivals
        Colony:new(
            {
                type = rival.type,
                x = rival.x,
                y = rival.y,
                population = rival.population,
                width = level.width,
                height = level.height
            }
        )
    end

    for i, predator in ipairs(level.predators) do
        -- Test for engine
        -- create predator enigne that adds entity
        local p = predator.type:new({x = predator.x, y = predator.y})
    end
end

function WorldMap:draw()
    local mouseX, mouseY = Lm.getPosition()
    Lg.draw(WorldMapBackground, 0, 0)

    local mouseCoorsX, mouseCoorsY = Cam:toWorld(mouseX, mouseY)

    for i, level in ipairs(Levels) do
        local inBetween =
            mouseCoorsX >= level.location.x and mouseCoorsY >= level.location.y and
            mouseCoorsX < level.location.x + level.colony.population / 10 * 2 and
            mouseCoorsY < level.location.y + level.colony.population / 10 * 2

        if inBetween then
            Lg.rectangle(
                "fill",
                level.location.x,
                level.location.y,
                level.colony.population / 10 + 5,
                level.colony.population / 10 + 5
            )

            function love.mousepressed(x, y, button)
                if button == 1 and GameState == 2 then
                    self:create(level)
                    GameState = 1
                    BackgroundImage = level.background
                end
            end
        else
            Lg.rectangle(
                "fill",
                level.location.x,
                level.location.y,
                level.colony.population / 10,
                level.colony.population / 10
            )
        end
    end
end

return WorldMap

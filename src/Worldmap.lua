local WorldMap = class("WorldMap")
local Levels = require "Levels"

function WorldMap:draw()
    local mouseX, mouseY = Lm.getPosition()
    Lg.draw(WorldMapBackground, 0, 0)

    local mouseCoorsX, mouseCoorsY = Cam:toWorld(mouseX, mouseY)

    for i, level in ipairs(Levels) do
        local inBetween =
            mouseCoorsX >= level.location.x and mouseCoorsY >= level.location.y and
            mouseCoorsX < level.location.x + level.population / 10 * 2 and
            mouseCoorsY < level.location.y + level.population / 10 * 2

        if inBetween then
            Lg.rectangle(
                "fill",
                level.location.x,
                level.location.y,
                level.population / 10 + 5,
                level.population / 10 + 5
            )

            function love.mousepressed(x, y, button)
                if button == 1 then
                    GameState = 1
                    BackgroundImage = level.background
                end
            end
        else
            Lg.rectangle("fill", level.location.x, level.location.y, level.population / 10, level.population / 10)
        end
    end
end

return WorldMap

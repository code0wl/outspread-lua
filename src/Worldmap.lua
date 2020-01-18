local WorldMap = class("WorldMap")
local levels = {}
local antHillSize = 20

function WorldMap:draw()
    local mouseX, mouseY = Lm.getPosition()
    Lg.draw(WorldMapBackground, 0, 0)

    -- Extract to own file later
    self:injectLevel(
        {
            location = {x = Lg.getWidth() / 2 + 200, y = Lg.getWidth() / 2 - 200},
            player = {},
            predators = {},
            rivals = {},
            background = BackgroundRocks
        }
    )

    self:injectLevel(
        {
            location = {x = util.getCenter(Lg.getWidth()) + 400, y = util.getCenter(Lg.getWidth()) - 400},
            player = {},
            predators = {},
            rivals = {},
            background = BackgroundImageGrass
        }
    )

    local mouseCoorsX, mouseCoorsY = Cam:toWorld(mouseX, mouseY)

    for i, level in ipairs(levels) do
        local inBetween =
            mouseCoorsX >= level.location.x and mouseCoorsY >= level.location.y and
            mouseCoorsX < level.location.x + antHillSize * 2 and
            mouseCoorsY < level.location.y + antHillSize * 2

        if inBetween then
            Lg.rectangle("fill", level.location.x, level.location.y, antHillSize + 5, antHillSize + 5)

            function love.mousepressed(x, y, button)
                if button == 1 then
                    GameState = 1
                    BackgroundImage = level.background
                end
            end
        else
            Lg.rectangle("fill", level.location.x, level.location.y, antHillSize, antHillSize)
        end
    end
end

function WorldMap:injectLevel(level)
    table.insert(levels, level)
end

return WorldMap

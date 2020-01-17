local WorldMap = class("WorldMap")
local levels = {}
local circleSize = 20

function WorldMap:draw()
    local mouseX, mouseY = Lm.getPosition()
    Lg.draw(WorldMapBackground, 0, 0)

    -- Extract to own file later
    self:injectLevel(
        {
            location = {x = Lg.getWidth() / 2 + 200, y = Lg.getWidth() / 2 - 200},
            player = {},
            predators = {},
            rivals = {}
        }
    )

    self:injectLevel(
        {
            location = {x = util.getCenter(Lg.getWidth()) + 400, y = util.getCenter(Lg.getWidth()) - 400},
            player = {},
            predators = {},
            rivals = {}
        }
    )

    local mouseCoorsX, mouseCoorsY = Cam:toWorld(mouseX, mouseY)

    for i, level in ipairs(levels) do
        local inBetween =
            mouseCoorsX >= level.location.x and mouseCoorsY >= level.location.y and
            mouseCoorsX < level.location.x + circleSize and
            mouseCoorsY < level.location.y + circleSize

        if inBetween then
            Lg.circle("fill", level.location.x, level.location.y, circleSize + 5, 20)
        else
            Lg.circle("fill", level.location.x, level.location.y, circleSize, 20)
        end

        function love.mousepressed(x, y, button)
            if button == 1 then
                GameState = 1
                BackgroundImage = BackgroundRocks
            end
        end
    end
end

function WorldMap:injectLevel(level)
    table.insert(levels, level)
end

return WorldMap

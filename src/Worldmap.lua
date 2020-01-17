local WorldMap = class("WorldMap")
local levels = {}
local circleSize = 20

function WorldMap:draw()
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
            location = {x = Lg.getWidth() / 2 + 400, y = Lg.getWidth() / 2 - 400},
            player = {},
            predators = {},
            rivals = {}
        }
    )

    for i, level in ipairs(levels) do
        Lg.circle("fill", level.location.x, level.location.y, circleSize, 20)

        function love.mousepressed(x, y, button)
            local inBetweenWidth = x > level.location.x and x < level.location.x / 2
            local inBetweenHeight = y > level.location.y and y < level.location.y / 2
            print("pressed before", x, level.location.x)

            if button == 1 and inBetweenWidth and inBetweenHeight then
                print("pressed")
                GameState = 1
                BackgroundImage = BackgroundRocks
            else
                return
            end
        end
    end
end

function WorldMap:injectLevel(level)
    table.insert(levels, level)
end

return WorldMap

local WorldMap = class("WorldMap")

function WorldMap:draw()
    local blockWidth = 300 / 2
    local blockHeight = 300 / 2
    local block_depth = blockHeight / 2.25
    local levels = {}
    local i = 0
    local grid_size = 5
    local graphic = nil
    local mouseX, mouseY = Lm.getPosition()

    for x = 1, grid_size do
        for y = 1, grid_size do
            i = i + 1
            local deltaX, deltaY =
                ((y - x) * (util.getCenter(blockWidth))),
                ((x + y) * (util.getCenter(block_depth))) - (block_depth * util.getCenter(grid_size))

            local dx, dy =
                util.getCenter(Lg.getWidth()) / grid_size + deltaX,
                util.getCenter(Lg.getHeight()) / grid_size + deltaY

            if i > 10 and i < 15 then
                graphic = SomeGrass
            elseif i > 15 and i < 20 then
                graphic = Sand
            elseif i == 25 then
                graphic = Rock
            else
                graphic = Grass
            end

            local level = {
                level = i,
                x = dx,
                y = dy,
                image = graphic
            }

            table.insert(levels, level)

            local mouseCoorsX, mouseCoorsY = Cam:toWorld(mouseX, mouseY)

            if
                mouseCoorsX >= dx and mouseCoorsX < dx + blockWidth and mouseCoorsY >= dy and
                    mouseCoorsY < dy + blockHeight
             then
                function love.mousepressed(mx, my, button)
                    if button == 1 then
                        BackgroundImage = BackgroundSand
                        GameState = 1
                    end
                end

                Lg.draw(level.image, dx, dy - 10, nil, .5)
            else
                Lg.draw(level.image, dx, dy, nil, .5)
            end
        end
    end
end

return WorldMap

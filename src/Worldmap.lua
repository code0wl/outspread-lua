local WorldMap = class("WorldMap")

function WorldMap:draw()
    local blockWidth = 300 / 2
    local blockHeight = 300 / 2
    local block_depth = blockHeight / 2.25
    local level = 0
    local grid_size = 5
    local graphic = nil
    local mouseX, mouseY = Lm.getPosition()

    for x = 1, grid_size do
        for y = 1, grid_size do
            level = level + 1
            local deltaX, deltaY =
                ((y - x) * (util.getCenter(blockWidth))),
                ((x + y) * (util.getCenter(block_depth))) - (block_depth * util.getCenter(grid_size))

            local dx, dy =
                util.getCenter(Lg.getWidth()) / grid_size + deltaX,
                util.getCenter(Lg.getHeight()) / grid_size + deltaY

            -- make into objects and loop
            if level > 10 and level < 15 then
                graphic = SomeGrass
            elseif level > 15 and level < 20 then
                graphic = Sand
            elseif level == 25 then
                graphic = Rock
            else
                graphic = Grass
            end

            local mouseCoorsX, mouseCoorsY = Cam:toWorld(mouseX, mouseY)
            if
                mouseCoorsX >= dx and mouseCoorsX < dx + blockWidth and mouseCoorsY >= dy and
                    mouseCoorsY < dy + blockHeight
             then
                function love.mousepressed(mx, my, button)
                    if button == 1 then
                        if level > 10 and level < 15 then
                            BackgroundImage = BackgroundImageGrass
                        elseif level > 15 and level < 20 then
                            BackgroundImage = BackgroundSand
                        elseif level == 25 then
                            BackgroundImage = BackgroundRocks
                        else
                            BackgroundImage = BackgroundDirt
                        end
                        GameState = 1
                    end
                    print(BackgroundImage)
                end

                Lg.draw(graphic, dx, dy - 10, nil, .5)
            else
                Lg.draw(graphic, dx, dy, nil, .5)
            end
        end
    end
end

return WorldMap

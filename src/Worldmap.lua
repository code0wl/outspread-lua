local WorldMap = class("WorldMap")

function WorldMap:draw()
    local block_width = Grass:getWidth()
    local block_height = Grass:getHeight()
    local block_depth = block_height / 2.25
    local level = 0
    local grid_size = 5
    local graphic = nil

    for x = 1, grid_size do
        for y = 1, grid_size do
            level = level + 1
            local deltaX, deltaY = ((y - x) * (block_width / 2)), ((x + y) *
                                       (block_depth / 2)) -
                                       (block_depth * (grid_size / 2))

            -- make into objects and loop
            if level > 0 and level < 10 then
                graphic = Grass
            elseif level > 10 and level < 20 then
                graphic = SomeGrass
            elseif level <= 20 and level > 23 then
                graphic = Sand
            elseif level == 25 then
                graphic = Rock
            else
                graphic = Grass
            end

            Lg.draw(graphic,
                    Lg.getWidth() / grid_size + deltaX - block_width + 60,
                    Lg.getHeight() / grid_size + deltaY + block_height / 2)

            suit.layout:reset(Lg.getWidth() / 2 + deltaX,
                              Lg.getHeight() / 2 + deltaY - 100)

            Lg.setColor(0, 0, 0, .4)
            suit.layout:row(40, 20)
            if suit.Button(level, suit.layout:row()).hit then
                print(level)
                GameState = 1
            end
            Lg.setColor(255, 255, 255, 1)
        end
    end
end

return WorldMap


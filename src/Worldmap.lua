local WorldMap = class("WorldMap")

function WorldMap:draw()
    local block_width = Grass:getWidth()
    local block_height = Grass:getHeight()
    local block_depth = block_height / 2.25

    local grid_size = 4

    for x = 1, grid_size do
        for y = 1, grid_size do
            local deltaX, deltaY = ((y - x) * (block_width / 2)), ((x + y) *
                                       (block_depth / 2)) -
                                       (block_depth * (grid_size / 2))

            -- make into objects and loop
            Lg.draw(Grass, Lg.getWidth() / grid_size + deltaX - block_width,
                    Lg.getHeight() / grid_size + deltaY + block_height)

            suit.layout:reset(Lg.getWidth() / 2 + deltaX,
                              Lg.getHeight() / 2 + deltaY)

            suit.layout:row(40, 20)

            if suit.Button('Helo', suit.layout:row()).hit then
                print('fucker')
            end
        end
    end
end

return WorldMap


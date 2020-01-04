local WorldMap = class("WorldMap")

function WorldMap:draw()
    local block_width = Grass:getWidth()
    local block_height = Grass:getHeight()
    local block_depth = block_height / 2.3

    local grid_x = 0
    local grid_y = 0
    local grid_size = 10

    for x = 1, grid_size do
        for y = 1, grid_size do
            -- make into objects and loop
            Lg.draw(Grass, grid_x + ((y - x) * (block_width / 2)), grid_y +
                        ((x + y) * (block_depth / 2)) -
                        (block_depth * (grid_size / 2)))

            suit.layout:reset(grid_x + ((y - x) * (block_width / 2)), grid_y +
                                  ((x + y) * (block_depth / 2)) -
                                  (block_depth * (10 / 2)))

            suit.layout:row(40, 30)

            if suit.Button(grid_x, suit.layout:row()).hit then
                print('fucker')
            end
        end
    end
end

return WorldMap


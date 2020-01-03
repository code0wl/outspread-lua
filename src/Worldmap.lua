local WorldMap = class("WorldMap")

function WorldMap:initialize(worldMapConfig) self.tilesToRender = {} end

function WorldMap:draw()

    block_width = Grass:getWidth()
    block_height = Grass:getHeight()
    block_depth = block_height / 2

    x = 0
    y = 0
    grid_x = 0
    grid_y = 0
    grid_size = 20
    grid = {}
    for x = 1, grid_size do
        grid[x] = {}
        for y = 1, grid_size do grid[x][y] = 1 end
    end

    grid[2][4] = 2
    grid[6][5] = 2

    for x = 1, grid_size do
        for y = 1, grid_size do
            if grid[x][y] == 1 then
                love.graphics.draw(Grass,
                                   grid_x + ((y - x) * (block_width / 2)),
                                   grid_y + ((x + y) * (block_depth / 2)) -
                                       (block_depth * (grid_size / 2)))

            end
        end
    end

    Lg.draw(Grass, grid_x + ((y - x) * (block_width / 2)), grid_y +
                ((x + y) * (block_depth / 2)) - (block_depth * (grid_size / 2)))
end

return WorldMap


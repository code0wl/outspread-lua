local WorldMap = class("WorldMap")

function WorldMap:initialize(worldMapConfig) self.tilesToRender = {} end

function WorldMap:draw()

    local block_width = Grass:getWidth()
    local block_height = Grass:getHeight()
    local block_depth = block_height / 2

    local x = 0
    local y = 0
    local grid_x = 0
    local grid_y = 0
    local grid_size = 10
    local grid = {}

    for x = 1, grid_size do
        grid[x] = {}
        for y = 1, grid_size do grid[x][y] = 1 end
    end

    for x = 1, grid_size do
        for y = 1, grid_size do
            if grid[x][y] == 1 then
                Lg.draw(Grass, grid_x + ((y - x) * (block_width / 2)), grid_y +
                            ((x + y) * (block_depth / 2)) -
                            (block_depth * (grid_size / 2)))

            end
        end
    end

    Lg.draw(Grass, grid_x + ((y - x) * (block_width / 2)), grid_y +
                ((x + y) * (block_depth / 2)) - (block_depth * (grid_size / 2)))
end

return WorldMap


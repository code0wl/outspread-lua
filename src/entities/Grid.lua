local Cell = require('entities.Cell')

local Grid = class('Grid', Entity)

function Grid:initialize(size)
    for i = 0, GlobalWidth, size do
        for j = 0, GlobalHeight, size do
            table.insert(CellStore,
                         Cell:new({width = size, height = size, x = i, y = j}))
        end
    end
end

function Grid:update()

    for i, ant in ipairs(CellStore) do

        for _, cell in ipairs(CellStore) do
            cell:emptyCell()
            print(ant)
        end

        -- Some other operation
    end
end

return Grid


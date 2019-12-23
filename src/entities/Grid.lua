local Cell = require('entities.Cell')

local Grid = class('Grid', Entity)

function Grid:initialize(size)
    for i = 0, GlobalWidth, 100 do
        for j = 0, GlobalHeight, 100 do
            table.insert(CellStore,
                         Cell:new({width = 100, height = 100, x = i, y = j}))
        end
    end
end

return Grid


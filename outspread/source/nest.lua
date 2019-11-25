local Ant = require("ant")

local Nest = {
}

function Nest:create(type, x, y, population)
    local nest = {}
    nest.type = type
    nest.population = population
    nest.x = x
    nest.y = y
    nest.ants = {}
    nest.width = 16
    nest.height = 27
    nest.graphic = lg.newQuad(300, 70, 80, 80, terrainSprites.terrain:getDimensions())
    nest.draw = function() lg.draw(terrainSprites.terrain, nest.graphic, nest.x, nest.y, nil, .4, .4) end

    for i = 0, nest.population do
        local ant = Ant:create(nest.type, x + i, y + i, 1)
        table.insert(nest.ants, ant)
    end

    return nest
end

return Nest

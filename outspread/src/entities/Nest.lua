local Ant = require("entities/Ant")

function Nest(nestConfig)
    local nest = {}
    nest.type = nestConfig.type
    nest.population = nestConfig.population
    nest.x = nestConfig.x
    nest.y = nestConfig.y
    nest.target = nil
    nest.collectedFood = 0
    nest.ants = {}
    nest.width = 16
    nest.height = 27

    nest.graphic = lg.newQuad(300, 70, 80, 80,
                              terrainSprites.terrain:getDimensions())

    for i = 0, nest.population do
        local ant = Ant({type = nest.type, x = nest.x, y = nest.y, state = 1})
        table.insert(nest.ants, ant)
    end

    function nest.draw()
        lg.draw(terrainSprites.terrain, nest.graphic, nest.x, nest.y, nil, .4,
                .4)
    end

    return nest
end

return Nest

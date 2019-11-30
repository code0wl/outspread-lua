local Ant = require("entities/Ant")

function Nest(nestConfig)
    local nest = {}
    nest.type = nestConfig.type
    nest.x = nestConfig.x
    nest.y = nestConfig.y
    nest.target = nil
    nest.startingPopulation = nestConfig.population
    nest.collectedFood = 0
    nest.ants = {}
    nest.width = 16
    nest.height = 27

    nest.graphic = lg.newQuad(300, 70, 80, 80,
                              terrainSprites.terrain:getDimensions())

    for i = 0, nest.startingPopulation do
        table.insert(nest.ants,
                     Ant({type = nest.type, x = nest.x, y = nest.y, state = 1}))
    end

    function nest.update()
        for i = 0, nest.collectedFood do
            nest.collectedFood = nest.collectedFood - 1
            table.insert(nest.ants, Ant({
                type = nest.type,
                x = nest.x,
                y = nest.y,
                state = 1
            }))
        end
    end

    function nest.draw()
        lg.draw(terrainSprites.terrain, nest.graphic, nest.x, nest.y, nil, .4,
                .4)
    end

    return nest
end

return Nest

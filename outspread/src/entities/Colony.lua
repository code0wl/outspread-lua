local Nest = require("entities/Nest")

Colonies = {}

function Colony(colonyConfig)
    local colony = {}
    colony.type = colonyConfig.type
    colony.population = colonyConfig.population
    colony.nest = Nest({
        type = colony.type,
        x = colonyConfig.x,
        y = colonyConfig.y,
        population = colonyConfig.population
    })
    world:add(colony.nest, colony.nest.x, colony.nest.y, colony.nest.height,
              colony.nest.width)
    table.insert(Colonies, colony)

    return colony
end

return Colony


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
    table.insert(Colonies, colony)

    return colony
end

return Colony


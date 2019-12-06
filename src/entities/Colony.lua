local Nest = require("entities/Nest")

local Colony = {}

function Colony:new(colonyConfig)
    local colony = setmetatable({}, {__index = Colony})

    colony.type = colonyConfig.type
    colony.population = colonyConfig.population
    colony.nest = Nest:new({
        type = colony.type,
        x = colonyConfig.x,
        y = colonyConfig.y,
        population = colonyConfig.population
    })

    return colony
end

return Colony


local Nest = require("nest")

local Colony = {}

function Colony:create(type, x, y, population)
    local colony = {}
    colony.type = type
    colony.population = population
    colony.nest = Nest:create(type, x, y, population)

    table.insert(Colony, colony)
end

return Colony


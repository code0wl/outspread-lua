local Nest = require("entities/Nest")

local Colony = class("Colony")

function Colony:init(type, x, y, population)
    self.type = type
    self.population = population
    self.nest = Nest(type, x, y, population)
    table.insert(Colony, self)
end

return Colony


local Nest = require("entities/Nest")

local Colony = class("Colony")

function Colony:init(colonyConfig)
    self.type = colonyConfig.type
    self.population = colonyConfig.population
    self.nest = Nest(self.type, colonyConfig.x, colonyConfig.y, colonyConfig.population)
    table.insert(Colony, self)
end

return Colony


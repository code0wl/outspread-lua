local Nest = require("entities/Nest")

local Colony = class("Colony", Entity)

function Colony:initialize(colonyConfig)
    Entity.initialize(self)

    self:add(Components.Colony(true))

    self.type = colonyConfig.type
    self.population = colonyConfig.population
    self.nest = Nest:new({
        type = self.type,
        x = colonyConfig.x,
        y = colonyConfig.y,
        population = colonyConfig.population
    })
end

return Colony


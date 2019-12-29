local Nest = require("entities/Nest")

local Colony = class("Colony")

function Colony:initialize(colonyConfig)
    self.type = colonyConfig.type
    self.population = colonyConfig.population

    self.nest = Nest:new({
        type = self.type,
        x = colonyConfig.x,
        y = colonyConfig.y,
        population = colonyConfig.population
    })

    engine:addEntity(self.nest)

end

return Colony


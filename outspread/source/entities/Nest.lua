local Ant = require("entities/Ant")

local Nest = class("Nest")

function Nest:init(type, x, y, population)
    self.type = type
    self.population = population
    self.x = x
    self.y = y
    self.ants = {}
    self.width = 16
    self.height = 27
    self.graphic = lg.newQuad(300, 70, 80, 80, terrainSprites.terrain:getDimensions())
    self.draw = function() lg.draw(terrainSprites.terrain, self.graphic, self.x, self.y, nil, .4, .4) end

    for i = 0, self.population do
        table.insert(self.ants, Ant(self.type, x + i, y + i, 1))
    end

end

return Nest

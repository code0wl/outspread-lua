local Ant = require("entities/Ant")

local Nest = class("Nest")

function Nest:init(nestConfig)
    self.type = nestConfig.type
    self.population = nestConfig.population
    self.x = nestConfig.x
    self.y = nestConfig.y
    self.target = nil
    self.collectedFood = 0
    self.ants = {}
    self.width = 16
    self.height = 27

    self.graphic = lg.newQuad(300, 70, 80, 80, terrainSprites.terrain:getDimensions())

    for i = 0, self.population do
        table.insert(self.ants, Ant({ type = self.type, x = self.x, y = self.y, state = 1 }))
    end
end

function Nest:draw()
    lg.draw(terrainSprites.terrain, self.graphic, self.x, self.y, nil, .4, .4)
end

return Nest

local WorkerAnt = require("entities/WorkerAnt")

local Nest = class('Nest', Entity)

function Nest:initialize(nestConfig)
    Entity.initialize(self)

    self.type = nestConfig.type
    self.x = nestConfig.x
    self.y = nestConfig.y
    self.target = nil
    self.startingPopulation = nestConfig.population
    self.collectedFood = 0
    self.ants = {}
    self.width = 16
    self.height = 27

    self.graphic = Lg.newQuad(300, 70, 80, 80,
                              TerrainSprites.terrain:getDimensions())

    for i = 0, self.startingPopulation do
        table.insert(self.ants, WorkerAnt:new(
                         {type = self.type, x = self.x, y = self.y, state = 1}))
    end

end

function Nest:update()
    for i = 1, self.collectedFood do
        self.collectedFood = self.collectedFood - 2
        table.insert(self.ants, WorkerAnt:new(
                         {type = self.type, x = self.x, y = self.y, state = 1}))
    end
end

function Nest:draw()
    Lg.draw(TerrainSprites.terrain, self.graphic, self.x, self.y, nil, .4, .4)
end

function Nest:addFood() self.collectedFood = self.collectedFood + 1 end

return Nest

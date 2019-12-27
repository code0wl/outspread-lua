local WorkerAnt = require("entities/WorkerAnt")

local Nest = class('Nest', Entity)

function Nest:initialize(nestConfig)
    Entity.initialize(self)

    self:add(Components.Position(nestConfig.x, nestConfig.y))
    self:add(Components.Dimension(16, 27))
    self:add(Components.Nest(true))
    self:add(Components.Scale(.4))
    self:add(Components.Static(true))

    self.amount = 0
    self.type = nestConfig.type
    self.startingPopulation = nestConfig.population
    self.graphic = Lg.newQuad(300, 70, 80, 80,
                              TerrainSprites.terrain:getDimensions())

    for i = 0, self.startingPopulation do
        engine:addEntity(WorkerAnt:new({type = self.type, nest = self}))
    end

end

function Nest:receiveFood(amount) self.amount = self.amount + amount end

return Nest

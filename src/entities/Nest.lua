local WorkerAnt = require("entities/WorkerAnt")

local Nest = class('Nest', Entity)

function Nest:initialize(nestConfig)
    Entity.initialize(self)

    self:add(Components.Position(nestConfig.x, nestConfig.y))
    self:add(Components.Dimension(16, 27))
    self:add(Components.Nest(true))

    self.type = nestConfig.type

    self.startingPopulation = nestConfig.population
    self.collectedFood = 0
    self.ants = {}

    self.graphic = Lg.newQuad(300, 70, 80, 80,
                              TerrainSprites.terrain:getDimensions())

    for i = 0, self.startingPopulation do
        engine:addEntity(WorkerAnt:new({
            type = self.type,
            x = nestConfig.x,
            y = nestConfig.y
        }))
    end

end

function Nest:update()
    local x, y = self:get("position").x, self:get("position").y
    for i = 1, self.collectedFood do
        self.collectedFood = self.collectedFood - 2
        engine:addEntity(WorkerAnt:new({type = self.type, x = x, y = y}))
    end
end

function Nest:draw()
    local x, y = self:get("position").x, self:get("position").y
    Lg.draw(TerrainSprites.terrain, self.graphic, x, y, nil, .4, .4)
end

function Nest:addFood() self.collectedFood = self.collectedFood + 1 end

return Nest

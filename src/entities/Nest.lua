local Ant = require("entities/Ant")

local Nest = {}

function Nest:new(nestConfig)
    local nest = setmetatable({}, {__index = Nest})
    nest.type = nestConfig.type
    nest.x = nestConfig.x
    nest.y = nestConfig.y
    nest.target = nil
    nest.startingPopulation = nestConfig.population
    nest.collectedFood = 0
    nest.ants = {}
    nest.width = 16
    nest.height = 27

    nest.graphic = Lg.newQuad(300, 70, 80, 80,
                              TerrainSprites.terrain:getDimensions())

    for i = 0, nest.startingPopulation do
        table.insert(nest.ants, Ant:new({
            type = nest.type,
            x = nest.x,
            y = nest.y,
            state = 1
        }))
    end

    return nest
end

function Nest:update()
    for i = 1, self.collectedFood do
        self.collectedFood = self.collectedFood - 2
        table.insert(self.ants, Ant:new({
            type = self.type,
            x = self.x,
            y = self.y,
            state = 1
        }))
    end
end

function Nest:draw()
    Lg.draw(TerrainSprites.terrain, self.graphic, self.x, self.y, nil, .4, .4)
end

function Nest:addFood() self.collectedFood = self.collectedFood + 1 end

return Nest

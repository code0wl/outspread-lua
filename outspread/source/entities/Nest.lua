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

    self.body = lp.newBody(myWorld, x, y, 'static')
    self.shape = lp.newRectangleShape(self.width, self.height)
    self.fixture = lp.newFixture(self.body, self.shape)
    self.body:setFixedRotation(true)

    self.graphic = lg.newQuad(300, 70, 80, 80, terrainSprites.terrain:getDimensions())

    for i = 0, self.population do
        table.insert(self.ants, Ant(self.type, x + i, y + i, 1))
    end
end

function Nest:draw()
    lg.draw(terrainSprites.terrain, self.graphic, self.body:getX(), self.body:getY(), nil, .4, .4)
end

return Nest

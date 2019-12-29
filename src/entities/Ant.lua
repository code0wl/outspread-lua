local Actor = require('entities.Actor')
local Ant = class('Ant', Actor)

function Ant:initialize(antConfig)
    Actor.initialize(self)

    self:add(Components.Ant(true))
    self.TimePassedAnt = 0
    self.type = antConfig.type
    self.hasFood = false
    self.nest = antConfig.nest

    -- Delta for nest location
    self.nestPosition = antConfig.nest:get('position')
    self.target = self.nestPosition
    self:add(Components.Position(self.nestPosition.x, self.nestPosition.y))
end

function Ant:carry(actor)
    actor:get('food').amount = actor:get('food').amount - 1
end

function Ant:collectFood(animal)
    self:get("food").amount = self:get("food").amount - animal.carryCapacity
end

return Ant

local Actor = require('entities.Actor')
local Ant = class('Ant', Actor)

function Ant:initialize(antConfig)
    Actor.initialize(self)

    self.TimePassedAnt = 0
    self.type = antConfig.type
    self.hasFood = false

    -- Delta for nest location
    local nestPosition = antConfig.nest:get('position')
    self.nest = antConfig.nest
    self.target = Components.Position(nestPosition.x, nestPosition.y)

    self:add(Components.Position(nestPosition.x, nestPosition.y))
    self:add(Components.Scale(.4))
    self:add(Components.Food(100))
    self:add(Components.Animation(true))
    self:add(Components.Ant(true))

end

function Ant:carry(actor)
    actor:get('food').amount = actor:get('food').amount - 1
    self.hasFood = true
end

function Ant:collectFood(animal)
    self:get("food").amount = self:get("food").amount - animal.carryCapacity
end

return Ant

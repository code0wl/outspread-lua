local Actor = require('entities.Actor')
local Ant = class('Ant', Actor)

function Ant:initialize(antConfig)
    Actor.initialize(self)

    self.TimePassedAnt = 0
    self.type = antConfig.type
    self.food = nil

    -- Delta for nest location
    local nestPosition = antConfig.nest:get('position')
    self.nest = antConfig.nest
    self.target = Components.Position(nestPosition.x, nestPosition.y)

    self:add(Components.Position(nestPosition.x, nestPosition.y))
    self:add(Components.Scale(.4))
    self:add(Components.Animation(true))
    self:add(Components.Ant(true))

end

function Ant:carry(actor)
    -- Carry other ant
    self.food = actor

end

return Ant

local Actor = require('entities.Actor')
local Ant = class('Ant', Actor)

function Ant:initialize(antConfig)
    Actor.initialize(self, antConfig)

    self.TimePassedAnt = 0
    self.type = antConfig.type
    self.hasFood = nil
    self.scentLocation = nil

    -- Delta for nest location
    self.nest = Components.Position(antConfig.x, antConfig.y)
    self.target = Components.Position(antConfig.x, antConfig.y)

    self:add(Components.Position(antConfig.x, antConfig.y))
    self:add(Components.Scale(.4))
    self:add(Components.Animation(true))
    self:add(Components.Ant(true))

end

return Ant

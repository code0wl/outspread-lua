local Ant = require('entities.Ant')

local ScoutAnt = class('ScoutAnt', Ant)

function ScoutAnt:initialize(antConfig)
    Ant.initialize(self, antConfig)

    self.carryCapacity = 0
    self:add(Components.Dimension(8, 14))
    self:add(Components.Scale(.2))
    self:add(Components.Velocity(280))
    self:add(Components.Energy(10, 5))
    self:add(Components.Food(1))
    self:add(Components.Attack(0))
    self:add(Components.Health(1))

    local nestPosition = antConfig.nest:get('position')
    world:add(self, nestPosition.x, nestPosition.y, 2, 2)

    if antConfig.type == 1 then self:add(Components.ScoutAnt(true)) end
end

return ScoutAnt

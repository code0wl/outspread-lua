local Ant = require('entities.Ant')

local SoldierAnt = class('SoldierAnt', Ant)

function SoldierAnt:initialize(antConfig)
    Ant.initialize(self, antConfig)

    self.carryCapacity = 4
    self:add(Components.Dimension(16, 27))
    self:add(Components.Scale(.6))
    self:add(Components.Velocity(70))
    self:add(Components.Energy(10, 5))
    self:add(Components.Food(20))
    self:add(Components.Attack(10))
    self:add(Components.Health(50))

    local nestPosition = antConfig.nest:get('position')
    world:add(self, nestPosition.x, nestPosition.y, 10, 10)

    if antConfig.type == 1 then self:add(Components.SoldierAnt(true)) end
end

return SoldierAnt

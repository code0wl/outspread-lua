local Ant = require('entities.Ant')

local SoldierAnt = class('SoldierAnt', Ant)

function SoldierAnt:initialize(antConfig)
    Ant.initialize(self, antConfig)

    self.carryCapacity = 2
    self:add(Components.Dimension(16, 27))
    self:add(Components.Scale(1))
    self:add(Components.Velocity(80))
    self:add(Components.Energy(10, 5))
    self:add(Components.Food(20))
    self:add(Components.Attack(10))
    self:add(Components.Health(50))

    local nestPosition = antConfig.nest:get('position')
    world:add(self, nestPosition.x, nestPosition.y, 10, 10)

    -- Make a util
    if self.type == 1 then
        self.image = BlackWalk
        self.grid = BlackWalkAnimationGrid
        self.animation = BlackWalkAnimation
    else
        self.image = RedWalk
        self.grid = RedWalkAnimationGrid
        self.animation = RedWalkAnimation
    end

end

return SoldierAnt

local DeadAnt = require('entities.DeadAnt')
local Ant = require('entities.Ant')

local WorkerAnt = class('WorkerAnt', Ant)

function WorkerAnt:initialize(antConfig)
    Ant.initialize(self, antConfig)

    self:add(Components.Dimension(16, 27))
    self:add(Components.Scale(.4))
    self:add(Components.Velocity(100))
    self:add(Components.Energy(10, 5))
    self:add(Components.Health(10, DeadAnt))

    self.damage = 1

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

return WorkerAnt

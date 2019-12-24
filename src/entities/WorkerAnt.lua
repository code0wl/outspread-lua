local Ant = require('entities.Ant')
local DeadAnt = require('entities.DeadAnt')

local WorkerAnt = class('WorkerAnt', Ant)

function WorkerAnt:initialize(antConfig)
    self.height = 27
    self.width = 16
    self.damage = 1

    Ant.initialize(self, antConfig)

    self:add(Components.Dimension(self.width, self.height))
    self:add(Components.Scale(.4))
    self:add(Components.Energy(10, 5))

    -- Make a util
    if self:get('ant').type == 1 then
        self.image = BlackWalk
        self.grid = BlackWalkAnimationGrid
        self.animation = BlackWalkAnimation
    else
        self.image = RedWalk
        self.grid = RedWalkAnimationGrid
        self.animation = RedWalkAnimation
    end

    self:add(Components.Health(10, DeadAnt))

end

return WorkerAnt

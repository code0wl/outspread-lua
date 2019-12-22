local Ant = require('entities.Ant')
local WorkerAnt = class('WorkerAnt', Ant)

function WorkerAnt:initialize(antConfig)
    Ant.initialize(self, antConfig)

    self:add(Components.Dimension(16, 27))
    self:add(Components.Scale(.4))
    self:add(Components.Energy(10, 5))
    self.speed = 120
    self.damage = 1

    local deadAnt = nil

    -- Make a util
    if self:get('ant').type == 1 then
        self.image = BlackWalk
        self.grid = BlackWalkAnimationGrid
        self.animation = BlackWalkAnimation
        deadAnt = DeadAntBlack
    else
        self.image = RedWalk
        self.grid = RedWalkAnimationGrid
        self.animation = RedWalkAnimation
        deadAnt = DeadAntRed
    end

    self:add(Components.Health(10, deadAnt))

    self:add(Components.Physics(self, antConfig.x, antConfig.y, 16, 27))

end

return WorkerAnt

local Ant = require('entities.Ant')
local WorkerAnt = class('WorkerAnt', Ant)

function WorkerAnt:initialize(antConfig)
    Ant.initialize(self, antConfig)
    self.speed = 120
    self.health = 10
    self.damage = 1
    self.width = 16
    self.height = 27

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

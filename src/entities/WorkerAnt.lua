local Ant = require('entities.Ant')

local WorkerAnt = class('WorkerAnt', Ant)

function WorkerAnt:initialize(antConfig)
    Ant.initialize(self, antConfig)
    self.speed = 90
    self.health = 10
    self.width = 16
    self.damage = 1
    self.height = 27

    self.image = Lg.newImage("images/ants/spritesheets/ant" .. self.type ..
                                 "/_ant_walk-small.png")

    self.grid = anim8.newGrid(self.width, self.height, self.image:getWidth(),
                              self.image:getHeight() + 1)

    self.animation = anim8.newAnimation(self.grid('1-5', 1, '1-5', 2, '1-5', 3),
                                        0.04)
end

return WorkerAnt

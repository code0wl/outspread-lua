local Spider = require('entities.Spider')
local SpiderTarantula = class('SpiderTarantula', Spider)

function SpiderTarantula:initialize(spiderConfig)
    Spider.initialize(self, spiderConfig)

    self:add(Components.Dimension(180, 150))
    self:add(Components.Health(200))
    self:add(Components.Velocity(80))
    self:add(Components.Energy(10, 50))
    self:add(Components.Attack(100))
    self:add(Components.Scale(1))
    self.image = WalkingTarantula

    local grid = anim8.newGrid(150, 180, self.image:getWidth(),
                               self.image:getHeight() + 1)

    self.animation = anim8.newAnimation(grid('1-2', 1, '1-2', 2, '1-2', 3,
                                             '1-2', 4, '1-2', 5), 0.15)

    world:add(self, spiderConfig.x, spiderConfig.y, 180, 150)

end

return SpiderTarantula


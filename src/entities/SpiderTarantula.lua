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

    local grid = anim8.newGrid(180, 150, self.image:getWidth(),
                               self.image:getHeight())

    self.animation = anim8.newAnimation(grid('1-5', 1, '1-5', 2), .04)

    world:add(self, spiderConfig.x, spiderConfig.y, 60, 60)

end

return SpiderTarantula


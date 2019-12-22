local Spider = require('entities.Spider')

local SpiderTarantula = class('SpiderTarantula', Spider)

function SpiderTarantula:initialize(spiderConfig)
    Spider.initialize(self, spiderConfig)

    self:add(Components.Dimension(180, 150))
    self:add(Components.Health(100, DeadTarantulaSpider))
    self:add(Components.Velocity(80))
    self.image = WalkingTarantula

    local grid = anim8.newGrid(180, 150, self.image:getWidth(),
                               self.image:getHeight() + 1)

    self.animation = anim8.newAnimation(grid('1-5', 1, '1-5', 2), 0.04)

    return Spider

end

return SpiderTarantula


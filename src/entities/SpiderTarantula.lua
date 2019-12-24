local Spider = require('entities.Spider')

local SpiderTarantula = class('SpiderTarantula', Spider)

function SpiderTarantula:initialize(spiderConfig)
    -- Has to be set before inherited
    self.height = 180
    self.width = 150
    self.damage = 100
    self.image = WalkingTarantula

    Spider.initialize(self, spiderConfig)

    self:add(Components.Dimension(self.width, self.height))
    self:add(Components.Health(100, DeadTarantulaSpider))
    self:add(Components.Velocity(80))
    self:add(Components.Energy(100, 50))
    self:add(Components.Scale(1))

    local grid = anim8.newGrid(self.width, self.height, self.image:getWidth(),
                               self.image:getHeight() + 1)

    self.animation = anim8.newAnimation(grid('1-2', 1, '1-2', 2, '1-2', 3,
                                             '1-2', 4, '1-2', 5), 0.15)

    return Spider

end

return SpiderTarantula


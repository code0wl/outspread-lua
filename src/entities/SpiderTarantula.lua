local Spider = require('entities.Spider')

local SpiderTarantula = class('SpiderTarantula', Spider)

function SpiderTarantula:initialize()
    Spider.initialize(self)
    self:add(Components.Dimension(180, 150))
    self.health = 100
    self.image = WalkingTarantula

    local grid = anim8.newGrid(180, 150, self.image:getWidth(),
                               self.image:getHeight() + 1)

    self.animation = anim8.newAnimation(grid('1-5', 1, '1-5', 2), 0.04)

end

return SpiderTarantula


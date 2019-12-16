local Spider = require('entities.Spider')

local SpiderTarantula = class('SpiderTarantula', Spider)

function SpiderTarantula:initialize()
    Spider.initialize(self)

    self.health = 100
    self.width = 180
    self.height = 150
    self.image = WalkingTarantula

    local grid = anim8.newGrid(self.width, self.height, self.image:getWidth(),
                               self.image:getHeight() + 1)

    self.animation = anim8.newAnimation(grid('1-5', 1, '1-5', 2), 0.04)

end

return SpiderTarantula


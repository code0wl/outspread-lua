local Spider = require('entities.Spider')
local SpiderTarantula = class('SpiderTarantula', Spider)

function SpiderTarantula:initialize(spiderConfig)
    Spider.initialize(self, spiderConfig)

    self.speed = 80
    self.maxEnergy = 1000
    self.energy = 10
    self.health = 10000
    self.width = 180
    self.height = 150

    self.image = Lg.newImage(
                     "images/spiders/spider1/spritesheets/sheet_spider_walk-small.png")

    self.grid = anim8.newGrid(self.width, self.height, self.image:getWidth(),
                              self.image:getHeight() + 1)

    self.animation = anim8.newAnimation(self.grid('1-5', 1, '1-5', 2), 0.04)

end

return SpiderTarantula


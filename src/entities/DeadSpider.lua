local DeadSpider = class('DeadSpider', Entity)

function DeadSpider:initialize(deadSpiderConfig)
    Entity.initialize(self)

    self.type = deadSpiderConfig.type
    self.x = deadSpiderConfig.x
    self.y = deadSpiderConfig.y
    self.angle = deadSpiderConfig.angle
    self:add(Components.Dimension(deadSpiderConfig.width,
                                  deadSpiderConfig.height))

    self.amount = 100

    self.image = DeadTarantulaSpider

end

function DeadSpider:draw() Lg.draw(self.image, self.x, self.y, self.angle) end

function DeadSpider:removeFood() self.amount = self.amount - 1 end

return DeadSpider

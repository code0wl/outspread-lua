local DeadSpider = class('DeadSpider', Entity)

function DeadSpider:initialize(deadSpiderConfig)

    self.width = deadSpiderConfig.width
    self.height = deadSpiderConfig.height

    Entity.initialize(self)

    self.type = deadSpiderConfig.type
    self.angle = deadSpiderConfig.angle
    self:add(Components.Food(100))
    self:add(Components.Scale(1))
    self:add(Components.Position(deadSpiderConfig.x, deadSpiderConfig.y))
    self:add(Components.Dimension(deadSpiderConfig.width,
                                  deadSpiderConfig.height))

    self.dead = true

    self.image = DeadTarantulaSpider

end

function DeadSpider:removeFood()
    local food = self:get("food")
    food.amount = food.amount - 1
end

return DeadSpider

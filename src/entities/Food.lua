local Food = class('Food')

function Food:initialize(foodConfig)
    self.x = foodConfig.x
    self.y = foodConfig.y
    self.amount = foodConfig.amount or 10
end

function Food:draw()
    Lg.setColor(255, 153, 153)
    Lg.circle("fill", self.x, self.y, self.amount)
end

function Food:removeFood() self.amount = self.amount - 1 end

return Food


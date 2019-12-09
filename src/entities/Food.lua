local Food = class('Food')

function Food:initialize(foodConfig)
    self.x = foodConfig.x
    self.y = foodConfig.y
    self.amount = 100
end

function Food:draw()
    if self.amount > 0 then
        Lg.setColor(255, 153, 153)
        Lg.circle("fill", self.x, self.y, self.amount)
    end
end

function Food:removeOneFood() self.amount = self.amount - 1 end

return Food


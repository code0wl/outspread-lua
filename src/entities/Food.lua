local Food = {}

function Food:new(foodConfig)
    local food = setmetatable({},{__index = Food})
    food.x = foodConfig.x
    food.y = foodConfig.y
    food.amount = 100
    return food
end

function Food:draw()
    if self.amount > 0 then
        lg.setColor(255, 153, 153)
        lg.circle("fill", self.x, self.y, self.amount)
    end
end

return Food


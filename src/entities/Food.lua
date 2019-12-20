local Food = class('Food', Entity)

function Food:initialize(foodConfig)
    Entity:initialize(self)
    self:add(Components.Position(foodConfig.x, foodConfig.y))
    self:add(Components.Food(foodConfig.amount or 10))
end

function Food:removeFood()
    local food = self:get("food")
    food.amount = food.amount - 1
end

return Food


local Food = require("entities/Food")

local FoodCollection = class("FoodCollection")

function FoodCollection:init(food)
    util.logTable(food)
    self.food = {}
    table.insert(self.food, Food(food))
end

function FoodCollection:draw()
    for i, f in ipairs(self.food) do
        f:draw()
    end
end

return FoodCollection


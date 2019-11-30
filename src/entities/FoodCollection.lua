local Food = require("entities/Food")

function FoodCollection(food)
    local collection = {}
    collection.food = {}

    table.insert(collection.food, Food(food))

    function collection.draw()
        for i, f in ipairs(collection.food) do f:draw() end
    end

    return collection
end

return FoodCollection


local Food = {}

function Food(foodConfig)
    local food = {}
    food.x = foodConfig.x
    food.y = foodConfig.y
    food.amount = 50
    food.width = 30
    food.height = 50

    function food.draw()
        if food.amount > 0 then
            lg.setColor(255, 153, 153)
            lg.circle("fill", food.x, food.y, food.amount)
        end
    end

    table.insert(foodCollection, food)

    return food

end

return Food


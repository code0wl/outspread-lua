local Food = {}

function Food(foodConfig)
    local food = {}
    local graphicWidth, graphicY
    food.x = foodConfig.x
    food.y = foodConfig.y
    food.amount = foodConfig.amount
    food.type = foodConfig.type
    food.width = 30
    food.height = 50

    function food.draw()

        if food.amount < 10 then
            graphicY = 342
        else
            if food.amount < 40 then
                graphicY = 390
            else
                graphicY = 420
            end
        end

        food.graphic = lg.newQuad(770, graphicY, food.width, food.height,
                                  foodSprites.food:getDimensions())

        if food.amount > 0 then
            lg.draw(foodSprites.food, food.graphic, food.x, food.y)
        else
            food = nil
        end
    end

    return food

end

return Food


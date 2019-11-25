local Food = class("Food")

function Food:init(type, x, y, amount)
    local graphicWidth, graphicY
    self.x = x
    self.y = y
    self.amount = amount
    self.type = type

    if amount < 10 then
        graphicY = 342
    else if amount < 40 then
        graphicY = 390
    else
        graphicY = 420
    end
    end

    self.graphic = lg.newQuad(770, graphicY, 30, 50, foodSprites.food:getDimensions())
    self.draw = function() lg.draw(foodSprites.food, self.graphic, self.x, self.y) end
end

return Food


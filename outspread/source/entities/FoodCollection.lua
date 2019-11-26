local Food = class("Food")

function Food:init(foodConfig)
    local graphicWidth, graphicY
    self.x = foodConfig.x
    self.y = foodConfig.y
    self.amount = foodConfig.amount
    self.type = foodConfig.type
    self.width = 30
    self.height = 50
end

function Food:draw()

    if self.amount < 10 then
        graphicY = 342
    else if self.amount < 40 then
        graphicY = 390
    else
        graphicY = 420
    end
    end

    self.graphic = lg.newQuad(770, graphicY, self.width, self.height, foodSprites.food:getDimensions())

    if self.amount > 0 then
        lg.draw(foodSprites.food, self.graphic, self.x, self.y)
    end
end

return Food


local Food = class("Food")

function Food:init(type, x, y, amount)
    local graphicWidth, graphicY
    self.x = x
    self.y = y
    self.amount = amount
    self.type = type
    self.width = 30
    self.height = 50
    self.body = lp.newBody(myWorld, x, y, 'static')
    self.shape = lp.newRectangleShape(self.width, self.height)
    self.fixture = lp.newFixture(self.body, self.shape)
    self.body:setFixedRotation(true)
    if amount < 10 then
        graphicY = 342
    else if amount < 40 then
        graphicY = 390
    else
        graphicY = 420
    end
    end

    self.graphic = lg.newQuad(770, graphicY, self.width, self.height, foodSprites.food:getDimensions())
end

function Food:draw()
    lg.draw(foodSprites.food, self.graphic, self.body:getX(), self.body:getY())
end

return Food


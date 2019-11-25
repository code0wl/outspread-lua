local Food = class("Food")

function Food:init(foodConfig)
    local graphicWidth, graphicY
    self.x = foodConfig.x
    self.y = foodConfig.y
    self.amount = foodConfig.amount
    self.type = foodConfig.type
    self.width = 30
    self.height = 50
    self.body = lp.newBody(myWorld, self.x, self.y, 'static')
    self.shape = lp.newRectangleShape(10, 10)
    self.fixture = lp.newFixture(self.body, self.shape)
    self.body:setFixedRotation(true)
    if self.amount < 10 then
        graphicY = 342
    else if self.amount < 40 then
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


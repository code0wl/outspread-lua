local DeadAnt = class('DeadAnt', Entity)

function DeadAnt:initialize(deadAntConfig)
    Entity.initialize(self)

    self.type = deadAntConfig.type
    self.x = deadAntConfig.x
    self.y = deadAntConfig.y
    self.angle = deadAntConfig.angle

    self:add(Components.Dimension(deadAntConfig.width, deadAntConfig.height))

    self.amount = 1

    -- Make a util
    if self.type == 1 then
        self.image = DeadAntBlack
    else
        self.image = DeadAntRed
    end

end

function DeadAnt:draw() Lg.draw(self.image, self.x, self.y, self.angle, .4, .4) end

function DeadAnt:removeFood() self.amount = self.amount - 1 end

return DeadAnt

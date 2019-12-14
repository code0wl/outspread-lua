local DeadAnt = class('DeadAnt')

function DeadAnt:initialize(deadAntConfig)

    self.type = deadAntConfig.type
    self.x = deadAntConfig.x
    self.y = deadAntConfig.y
    self.angle = deadAntConfig.angle
    self.height = deadAntConfig.height
    self.width = deadAntConfig.width

    -- Make a util
    if self.type == 1 then
        self.image = DeadAntBlack
    else
        self.image = DeadAntRed
    end

end

function DeadAnt:draw()
    love.graphics.draw(self.image, self.x, self.y, self.angle, .4, .4)
end

return DeadAnt

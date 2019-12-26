local DeadAnt = class('DeadAnt', Entity)

function DeadAnt:initialize(deadAntConfig)
    Entity.initialize(self)

    self.type = deadAntConfig.type
    self.angle = deadAntConfig.angle
    self:add(Components.Food(1))
    self:add(Components.Position(deadAntConfig.x, deadAntConfig.y))
    self:add(Components.Dimension(deadAntConfig.width, deadAntConfig.height))
    self:add(Components.Scale(.4))

    -- Make a util
    if self.type == 1 then
        self.image = DeadAntBlack
    else
        self.image = DeadAntRed
    end

end

return DeadAnt

local Actor = require("entities.Actor")
local DeadAnt = class('DeadAnt', Actor)

function DeadAnt:initialize(deadAntConfig)
    self.width = deadAntConfig.width
    self.height = deadAntConfig.height
    self.dead = true
    self.type = deadAntConfig.type
    self.angle = deadAntConfig.angle

    if self.type == 1 then
        self.image = DeadAntBlack
    else
        self.image = DeadAntRed
    end

    Actor.initialize(self)
    self:add(Components.Food(1))
    self:add(Components.Position(deadAntConfig.x, deadAntConfig.y))
    self:add(Components.Dimension(deadAntConfig.width, deadAntConfig.height))
    self:add(Components.Scale(.4))
end

return DeadAnt

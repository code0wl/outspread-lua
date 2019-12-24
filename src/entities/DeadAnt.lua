local Actor = require("entities.Actor")
local DeadAnt = class('DeadAnt', Actor)

function DeadAnt:initialize(deadAntConfig)
    self.width = deadAntConfig.width
    self.height = deadAntConfig.height
    self.dead = true

    Actor.initialize(self)

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

function DeadAnt:removeFood()
    local food = self:get("food")
    food.amount = food.amount - 1
end

return DeadAnt

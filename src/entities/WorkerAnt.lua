local Ant = require("entities.Ant")

local WorkerAnt = class("WorkerAnt", Ant)

function WorkerAnt:initialize(antConfig)
    Ant.initialize(self, antConfig)
    self.player = antConfig.player
    self.carryCapacity = 2
    self:add(Components.Dimension(16, 27))
    self:add(Components.Scale(.5))
    self:add(Components.Velocity(100))
    self:add(Components.Energy(10, 5))
    self:add(Components.Food(5))
    self:add(Components.Attack(2))
    self:add(Components.Health(10))

    local nestPosition = antConfig.nest:get("position")
    world:add(self, nestPosition.x, nestPosition.y, 5, 5)

    if antConfig.type == 1 then
        self:add(Components.WorketAnt(true))
    end
end

return WorkerAnt

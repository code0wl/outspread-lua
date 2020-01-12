local Spider = require("entities.Spider")
local SpiderTarantula = class("SpiderTarantula", Spider)

function SpiderTarantula:initialize(spiderConfig)
    local dimensions = {width = 180, height = 152}
    self.image = WalkingTarantula
    Spider.initialize(self, dimensions)

    self:add(Components.Dimension(dimensions.width, dimensions.height))
    self:add(Components.Health(4000))
    self:add(Components.Velocity(80))
    self:add(Components.Energy(10, 50))
    self:add(Components.Attack(0))
    self:add(Components.Food(500))
    self:add(Components.Scale(1))
    self:add(Components.Stats(true))
    self:add(Components.Position(spiderConfig.x, spiderConfig.y))
    self.target = Components.Position(spiderConfig.x, spiderConfig.y)

    world:add(self, spiderConfig.x, spiderConfig.y, 50, 50)
end

return SpiderTarantula

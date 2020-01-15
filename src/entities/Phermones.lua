local Actor = require("entities.Actor")

local Phermones = class("Phermones", Actor)

function Phermones:initialize()
    Actor.initialize(self)
    self:add(Components.Phermones(10, 10))
end

return Phermones

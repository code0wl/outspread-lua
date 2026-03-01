-- A chunk of a dead spider body that multiple ants must work together to carry.
local BodyPart = class("BodyPart", Entity)

-- Muted brown/amber colour to distinguish from red food pellets
local PART_COLOUR = { 0.55, 0.30, 0.10 }

function BodyPart:initialize(config)
    Entity.initialize(self)

    self.isAlive          = false -- not a combatant
    self.requiredCarriers = config.requiredCarriers or 3

    self:add(Components.Position(config.x, config.y))
    self:add(Components.Food(config.food or 30))
    self:add(Components.BodyPart(self.requiredCarriers))

    self.colour = PART_COLOUR
    self.radius = config.radius or 6 -- visual size

    engine:addEntity(self)
    world:add(self, config.x, config.y, self.radius * 2, self.radius * 2)
end

return BodyPart

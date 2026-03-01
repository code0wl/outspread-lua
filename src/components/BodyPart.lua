Components.BodyPart = Component.create("bodyPart")

-- requiredCarriers: how many ants must be nearby simultaneously to start lifting this chunk
function Components.BodyPart:initialize(requiredCarriers)
    self.requiredCarriers = requiredCarriers or 3
end

-- Marker component for scattered pickable food pellets spawned on death.
-- radius and colour are stored directly on the entity table (like BodyPart).
Components.FoodPellet = Component.create("foodPellet")

function Components.FoodPellet:initialize(radius, colour)
    self.radius = radius or 3
    self.colour = colour or { 1, 0.8, 0.15 }
end

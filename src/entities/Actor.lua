local Actor = class('Actor', Entity)

function Actor:initialize()
    Entity.initialize(self)
    self.scentLocation = nil
    self.isAlive = true
end

function Actor:attack(animal)
    animal:get('health').amount = animal:get('health').amount - self:get('attack').damage
    self.scentLocation = animal:get('position')
end

function Actor:eat(animal)
    -- Guard: animal must have a health component to eat
    local animalHealth = animal:has("health") and animal:get("health")
    if not animalHealth then return end
    local myHealth = self:get("health")
    if not myHealth then return end
    myHealth.amount = animalHealth.amount + self:get("food").amount
end

return Actor

local Actor = class('Actor', Entity)

function Actor:initialize()
    Entity.initialize(self)
    self.isAlive = true
    self.scentLocation = nil
    self.maxHealth = self.health or 100
end

function Actor:eat(animal, energy, speed)
    if util.distanceBetween(animal.x, animal.y, self.x, self.y) < animal.width then
        animal.isAlive = false
    end
end

function Actor:fightMode(isActive) self.aggressionSignalActive = isActive end

function Actor:attack(animal) animal.health = animal.health - self.damage end

return Actor

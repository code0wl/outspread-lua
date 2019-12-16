local Actor = class('Actor', Entity)

function Actor:initialize()
    Entity.initialize(self)
    self.isAlive = true
    self.scentLocation = nil
    self.maxHealth = self.health or 100
end

function Actor:eat(prey)

    if util.distanceBetween(prey.x, prey.y, self:get("position").x,
                            self:get("position").y) < prey.width then
        prey.isAlive = false
    end
end

function Actor:fightMode(isActive) self.aggressionSignalActive = isActive end

function Actor:attack(animal) animal.health = animal.health - self.damage end

return Actor

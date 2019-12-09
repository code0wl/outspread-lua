local Actor = class('Actor')

function Actor:initialize()
    self.isAlive = true
    self.scentLocation = nil
    self.maxHealth = self.health or 100
end

function Actor:update(dt)
    if self.isAlive then
        if self.health < 1 then self.isAlive = false end
        self.animation:update(dt)
    end
end

function Actor:heal(amount)
    if self.health < self.maxHealth then self.health = self.health + amount end
end

function Actor:eat(animal, energy, speed)
    if util.distanceBetween(animal.x, animal.y, self.x, self.y) < animal.width then
        self.energy = self.energy + energy
        self.speed = speed
        animal.isAlive = false
        self:heal(energy)
    end
end

function Actor:attack(animal) animal.health = animal.health - self.damage end

return Actor
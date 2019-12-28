local Actor = class('Actor', Entity)

function Actor:initialize()
    Entity.initialize(self)
    self.scentLocation = nil
    self.isAlive = true
    self.maxHealth = self.health or 100
end

function Actor:attack(animal)
    animal:get('health').amount = animal:get('health').amount - self:get('attack').damage
end

return Actor

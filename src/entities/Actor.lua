local Actor = class('Actor', Entity)

function Actor:initialize(config)
    Entity.initialize(self)
    self.isAlive = true
    self.scentLocation = nil
    self.maxHealth = self.health or 100

    world:add(self, config.x, config.y, 5, 5)
end

function Actor:eat(prey)
    if util.distanceBetween(prey:get("position").x, prey:get("position").y,
                            self:get("position").x, self:get("position").y) <
        prey:get("dimension").width then prey.isAlive = false end
end

function Actor:fightMode(isActive) self.aggressionSignalActive = isActive end

function Actor:attack(animal)
    if not animal:get('health').amount then return end
    animal:get('health').amount = animal:get('health').amount - self.damage
end

return Actor

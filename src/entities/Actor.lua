local Actor = class('Actor', Entity)

function Actor:initialize(config)
    Entity.initialize(self)
    self.body = Lp.newBody(world, 10, 10, "dynamic")
    self.shape = Lp.newRectangleShape(10, 10)
    self.fixture = Lp.newFixture(self.body, self.shape)
    self.body:setSleepingAllowed(true)
end

function Actor:eat(prey)
    if util.distanceBetween(prey:get("position").x, prey:get("position").y,
                            self:get("position").x, self:get("position").y) <
        prey:get("dimension").width then prey.isAlive = false end
end

function Actor:fightMode(isActive) self.aggressionSignalActive = isActive end

function Actor:attack(animal)
    if not self.damage then return end
    animal:get('health').amount = animal:get('health').amount - self.damage 
end

return Actor

local Actor = class('Actor', Entity)

function Actor:initialize()
    Entity.initialize(self)
    self.scentLocation = nil
    self.isAlive = true
    self:add(Components.Animation(true))
end

function Actor:attack(animal)
    animal:get('health').amount = animal:get('health').amount - self:get('attack').damage
    self.scentLocation = animal:get('position')
end

return Actor

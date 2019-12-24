local Actor = class('Actor', Entity)

function Actor:initialize()
    Entity.initialize(self)

    self.body = Lp.newBody(world, self.width, self.height, "dynamic")
    self.shape = Lp.newRectangleShape(self.width / 2, self.height / 2)
    self.fixture = Lp.newFixture(self.body, self.shape)
    self.body:setSleepingAllowed(true)

    self.fixture:setUserData(self)
end

function Actor:carry(B) 
    if self:get('ant') then
        self:get('carry').actor = B
    end
end

function Actor:attack(animal)
    animal:get('health').amount = animal:get('health').amount - self.damage
end

return Actor

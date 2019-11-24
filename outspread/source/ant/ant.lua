Ant = {}

function Ant:create(type)
    self.type = type
    self.images = {
        walk = lg.newImage("images/ants/spritesheets/ant1/_ant_walk-small.png"),
        dead = lg.newImage("images/ants/spritesheets/ant1/_ant_dead-small.png"),
        idle = lg.newImage("images/ants/spritesheets/ant1/_ant_idle-small.png")
    }
    self.x = 0
    self.y = 0
    self.currentState = self.images.walk
    self.body = lp.newBody(antWorld, 100, 100, "dynamic")
    self.shape = lp.newRectangleShape(66, 92)
    self.fixture = lp.newFixture(self.body, self.shape)
    self.speed = 200
    self.direction = 1
    self.alive = true
    self.body:setFixedRotation(true)
    self.grid = anim8.newGrid(16, 26, self.currentState:getWidth(), self.currentState:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-5', 1, '1-5', 2, '1-5', 3), 0.04)
    return self
end

function Ant:update(dt)
    self.animation:update(dt)
end

function Ant:draw()
    self.animation:draw(self.currentState, self.x, self.y)
end




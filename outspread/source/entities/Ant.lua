local Ant = class("Ant")

function Ant:init(type, x, y, state)
    self.state = state
    self.type = type
    self.images = {
        lg.newImage("images/ants/spritesheets/ant" .. type .. "/_ant_walk-small.png"),
        lg.newImage("images/ants/spritesheets/ant" .. type .. "/_ant_dead-small.png"),
    }
    self.x = x
    self.y = y
    self.currentState = self.images[self.state]
    self.speed = 200
    self.width = 16
    self.height = 27
    self.body = lp.newBody(myWorld, x, y, 'dynamic')
    self.shape = lp.newRectangleShape(self.width, self.height)
    self.fixture = lp.newFixture(self.body, self.shape)
    self.body:setFixedRotation(true)
    self.direction = 1
    self.alive = true
    self.grid = anim8.newGrid(self.width, self.height, self.currentState:getWidth(), self.currentState:getHeight() + 1)
    self.animation = anim8.newAnimation(self.grid('1-5', 1, '1-5', 2, '1-5', 3), 0.04)

end

return Ant


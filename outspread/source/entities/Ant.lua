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
    self.hasFood = nil
    self.currentState = self.images[self.state]
    self.speed = 7
    self.width = 16
    self.height = 27
    self.alive = true
    self.grid = anim8.newGrid(self.width, self.height, self.currentState:getWidth(), self.currentState:getHeight() + 1)
    self.animation = anim8.newAnimation(self.grid('1-5', 1, '1-5', 2, '1-5', 3), 0.04)
end

function Ant:update(dt)
    self.animation:update(dt)
end

function Ant:draw()
    self.animation:draw(self.currentState,
        self.y,
        self.x,
        nil,
        .6, .6,
        util.getCenter(self.width),
        util.getCenter(self.height))
end

return Ant


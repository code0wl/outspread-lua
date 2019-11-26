local Ant = class("Ant")

function Ant:init(antConfig)
    self.state = antConfig.state
    self.type = antConfig.type

    self.images = {
        lg.newImage("images/ants/spritesheets/ant" .. self.type .. "/_ant_walk-small.png"),
        lg.newImage("images/ants/spritesheets/ant" .. self.type .. "/_ant_dead-small.png"),
    }

    self.x = antConfig.x
    self.y = antConfig.y
    self.hasFood = nil
    self.currentState = self.images[self.state]
    self.speed = 100
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
        self.x,
        self.y,
        util.getAngle(self.target.y, self.y, self.target.x, self.x) + 1.6 + math.pi,
        .6, .6,
        util.getCenter(self.width),
        util.getCenter(self.height))

    if self.hasFood then
        lg.setColor(255, 153, 153)
        lg.circle("fill", self.x, self.y, 2, 10)
    end
end


return Ant


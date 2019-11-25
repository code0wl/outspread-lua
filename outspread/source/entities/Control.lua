local Control = class("Control")

function Control:init(speed)
    self.speed = speed
end

function Control:update(dt)
    if love.keyboard.isDown("up") then cam:move(0, -self.speed.panspeed * dt) end
    if love.keyboard.isDown("left") then cam:move(-self.speed.panspeed * dt, 0) end
    if love.keyboard.isDown("right") then cam:move(self.speed.panspeed * dt, 0) end
    if love.keyboard.isDown("down") then cam:move(0, self.speed.panspeed * dt) end
end

return Control

local Control = class("Control")

function Control:init(speed)
    self.panspeed = speed
end

function Control:update(dt)
    if love.keyboard.isDown("up") then cam:move(0, -self.panspeed * dt) end
    if love.keyboard.isDown("left") then cam:move(-self.panspeed * dt, 0) end
    if love.keyboard.isDown("right") then cam:move(self.panspeed * dt, 0) end
    if love.keyboard.isDown("down") then cam:move(0, self.panspeed * dt) end
end

return Control

local Control = {}

local scrollSpeed = 1500

function Control.update(dt)
    local currentX, currentY = Cam:getPosition()

    if love.keyboard.isDown("up") then
        Cam:setPosition(currentX, currentY - scrollSpeed * dt)
    end
    if love.keyboard.isDown("left") then
        Cam:setPosition(currentX - scrollSpeed * dt, currentY)
    end
    if love.keyboard.isDown("right") then
        Cam:setPosition(currentX + scrollSpeed * dt, currentY)
    end
    if love.keyboard.isDown("down") then
        Cam:setPosition(currentX, currentY + scrollSpeed * dt)
    end
end

return Control

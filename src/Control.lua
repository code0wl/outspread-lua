local Control = {}

local scrollSpeed = 1500

function Control.update(dt)
    local currentX, currentY = cam:getPosition()

    if love.keyboard.isDown("up") then
        cam:setPosition(currentX, currentY - scrollSpeed * dt)
    end
    if love.keyboard.isDown("left") then
        cam:setPosition(currentX - scrollSpeed * dt, currentY)
    end
    if love.keyboard.isDown("right") then
        cam:setPosition(currentX + scrollSpeed * dt, currentY)
    end
    if love.keyboard.isDown("down") then
        cam:setPosition(currentX, currentY + scrollSpeed * dt)
    end
end

return Control

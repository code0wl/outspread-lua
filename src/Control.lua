local Control = {}

local scrollSpeed = 1500

function Control.update(dt)
    local currentX, currentY = Cam:getPosition()

    if Lk.isDown("up") then
        Cam:setPosition(currentX, currentY - scrollSpeed * dt)
    end
    if Lk.isDown("left") then
        Cam:setPosition(currentX - scrollSpeed * dt, currentY)
    end

    if Lk.isDown("up") and Lk.isDown("left") then
        Cam:setPosition(currentX - scrollSpeed * dt, currentY - scrollSpeed * dt)
    end

    if Lk.isDown("right") then
        Cam:setPosition(currentX + scrollSpeed * dt, currentY)
    end

    if Lk.isDown("up") and Lk.isDown("right") then
        Cam:setPosition(currentX + scrollSpeed * dt, currentY - scrollSpeed * dt)
    end

    if Lk.isDown("down") then
        Cam:setPosition(currentX, currentY + scrollSpeed * dt)
    end

    if Lk.isDown("right") and Lk.isDown("down") then
        Cam:setPosition(currentX + scrollSpeed * dt, currentY + scrollSpeed * dt)
    end


    if Lk.isDown("left") and Lk.isDown("down") then
        Cam:setPosition(currentX - scrollSpeed * dt, currentY + scrollSpeed * dt)
    end

end

return Control

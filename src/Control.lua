local Control = {}

local scrollSpeed = 1500

local windowHeight = Lg.getHeight()
local windowWidth = Lg.getWidth()

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

    -- make into objects and loop
    suit.layout:reset(20, windowHeight - 80)

    suit.layout:row(100, 30)

    if suit.Button("Worker", suit.layout:row()).hit then print("Worker") end

    suit.layout:reset(140, windowHeight - 80)

    suit.layout:row(100, 30)

    if suit.Button("Soldier", suit.layout:row()).hit then print("Soldier") end

    suit.layout:reset(260, windowHeight - 80)

    suit.layout:row(100, 30)

    if suit.Button("Scout", suit.layout:row()).hit then
        print('creating scount')
    end

end

return Control

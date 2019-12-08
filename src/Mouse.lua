local maxZoom = 4
local maxOut = 0
local currentScale = 1
local scrollThreshold = 20
local scrollSpeed = 10

local function isScrollingLeft(mouseX) return mouseX < scrollThreshold end

local function isScrollingRight(mouseX)
    return mouseX > (Lg.getWidth() - scrollThreshold)
end

local function isScrollingTop(mouseY) return mouseY < scrollThreshold end

local function isScrollingDown(mouseY)
    return mouseY > (Lg.getHeight() - scrollThreshold)
end

local function dragMouse(x, y, dx, dy)
    local currentX, currentY = Cam:getPosition()

    if Lm.isDown(2) or Lm.isDown(3) then
        Cam:setPosition(currentX - dx, currentY - dy)
    end

    if Lm.isDown(1) then
        local phermone = {x = x, y = y, dx = dx, dy = dy}
        table.insert(Player.phermones, phermone)
    end
end

-- fix zoom bug when max zoom is active user can keep scrolling
function love.wheelmoved(x, y)
    if y > 0 and Cam.scale < maxZoom then
        currentScale = currentScale + .2
        Cam:setScale(currentScale)
    elseif y < 0 and Cam.scale > maxOut then
        currentScale = currentScale - .2
        Cam:setScale(currentScale)
    end
end

function love.mousemoved(x, y, dx, dy, istouch) dragMouse(x, y, dx, dy) end

function UpdateCameraLocation(mouseX, mouseY, currentX, currentY)
    if isScrollingLeft(mouseX) then
        Cam:setPosition(currentX - scrollSpeed, currentY)
    end

    if isScrollingTop(mouseY) then
        Cam:setPosition(currentX, currentY - scrollSpeed)
    end

    if isScrollingLeft(mouseX) and isScrollingTop(mouseY) then
        Cam:setPosition(currentX - scrollSpeed, currentY - scrollSpeed)
    end

    if isScrollingRight(mouseX) then
        Cam:setPosition(currentX + scrollSpeed, currentY)
    end

    if isScrollingRight(mouseX) and isScrollingTop(mouseY) then
        Cam:setPosition(currentX + scrollSpeed, currentY - scrollSpeed)
    end

    if isScrollingDown(mouseY) then
        Cam:setPosition(currentX, currentY + scrollSpeed)
    end

    if isScrollingDown(mouseY) and isScrollingRight(mouseX) then
        Cam:setPosition(currentX + scrollSpeed, currentY + scrollSpeed)
    end

    if isScrollingDown(mouseY) and isScrollingLeft(mouseX) then
        Cam:setPosition(currentX - scrollSpeed, currentY + scrollSpeed)
    end

end



function love.mousepressed(x, y, button, istouch)
    if button == 1 then Player.phermones = {} end
end

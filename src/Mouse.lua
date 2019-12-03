local maxZoom = 4
local maxOut = 0
local currentScale = 1
local scrollThreshold = 50
local scrollSpeed = 10

function love.wheelmoved(x, y)
    if y > 0 and cam.scale < maxZoom then
        currentScale = currentScale + .2
        cam:setScale(currentScale)
    elseif y < 0 and cam.scale > maxOut then
        currentScale = currentScale - .2
        cam:setScale(currentScale)
    end
end

function love.mousemoved(x, y, dx, dy, istouch) dragMouse(x, y, dx, dy) end

function updateCameraLocation(mouseX, mouseY, currentX, currentY)
    if isScrollingLeft(mouseX) then
        cam:setPosition(currentX - scrollSpeed, currentY)
    end

    if isScrollingTop(mouseY) then
        cam:setPosition(currentX, currentY - scrollSpeed)
    end

    if isScrollingLeft(mouseX) and isScrollingTop(mouseY) then
        cam:setPosition(currentX - scrollSpeed, currentY - scrollSpeed)
    end

    if isScrollingRight(mouseX) then
        cam:setPosition(currentX + scrollSpeed, currentY)
    end

    if isScrollingRight(mouseX) and isScrollingTop(mouseY) then
        cam:setPosition(currentX + scrollSpeed, currentY - scrollSpeed)
    end

    if isScrollingDown(mouseY) then
        cam:setPosition(currentX, currentY + scrollSpeed)
    end

    if isScrollingDown(mouseY) and isScrollingRight(mouseX) then
        cam:setPosition(currentX + scrollSpeed, currentY + scrollSpeed)
    end

    if isScrollingDown(mouseY) and isScrollingLeft(mouseX) then
        cam:setPosition(currentX - scrollSpeed, currentY + scrollSpeed)
    end

end

function isScrollingLeft(mouseX) return mouseX < scrollThreshold end
function isScrollingRight(mouseX)
    return mouseX > (lg.getWidth() - scrollThreshold)
end
function isScrollingTop(mouseY) return mouseY < scrollThreshold end
function isScrollingDown(mouseY)
    return mouseY > (lg.getHeight() - scrollThreshold)
end

function dragMouse(x, y, dx, dy)
    if lm.isDown(2) then
        local currentX, currentY = cam:getPosition()
        cam:setPosition(currentX - dx, currentY - dy)
    end

    if lm.isDown(1) then
        local phermone = {x = x, y = y}
        table.insert(userPhermones, phermone)
    end
end

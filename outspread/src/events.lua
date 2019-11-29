local maxZoom = 2
local maxOut = .9

function love.wheelmoved(x, y)
    if y > 0 and cam.scale < maxZoom then
        cam:zoom(1.05)
    elseif y < 0 and cam.scale > maxOut then
        cam:zoom(.95)
    end
    lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

local function dragmoved(x, y, dx, dy)

    if love.mouse.isDown(1) then cam:lockPosition(x + math.pi, y + math.pi) end

end

function love.mousemoved(x, y, dx, dy, istouch) dragmoved(x, y, dx, dy) end

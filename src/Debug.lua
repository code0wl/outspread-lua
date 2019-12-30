function PrintDetailsToScreen()
    local ants = PlayerColony.nest.ants

    Lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)

    Lg.print("Total Workers: " .. engine:getEntityCount('player'), 10, 50)

end

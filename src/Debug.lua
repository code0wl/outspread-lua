function PrintDetailsToScreen()
    local ants = PlayerColony.nest.ants

    Lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)

    Lg.print("Total Workers: " .. tostring(ants.workers), 10, 50)

    Lg.print("Total Soldiers: " .. tostring(ants.soldiers), 10, 90)

    Lg.print("Total Scouts: " .. tostring(ants.scouts), 10, 130)

end

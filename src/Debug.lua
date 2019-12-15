function PrintDetailsToScreen(Colonies)
    Lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)

    Lg.print("Current black Pop : " ..
                 tostring(table.getn(Colonies[1].nest.ants)), 10, 40)

    Lg.print(
        "Current red Pop : " .. tostring(table.getn(Colonies[2].nest.ants)), 10,
        70)

    Lg.print("Current food on map : " .. tostring(table.getn(FoodCollection)),
             10, 100)

end

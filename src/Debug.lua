function printDetailsToScreen(Colonies)
    lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)

    lg.print("Current black Pop : " ..
                 tostring(table.getn(Colonies[1].nest.ants)), 10, 40)

    lg.print(
        "Current red Pop : " .. tostring(table.getn(Colonies[2].nest.ants)), 10,
        70)

    love.graphics.print('Memory actually used (in kB): ' ..
                            collectgarbage('count'), 10, 100)
end

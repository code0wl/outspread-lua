function PrintDetailsToScreen(Colonies)
    Lg.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)

    for i, ants in ipairs(Colonies) do
        Lg.print(
            "Current " .. i .. ": " .. tostring(table.getn(ants.nest.ants)), 10,
            30 * i)
    end

end

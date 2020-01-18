function Hud()
    -- hud draw
    Lg.setColor(0, 0, 0, .4)
    Lg.rectangle("fill", 0, 0, Lg.getWidth() * .75, 35)
    Lg.setColor(255, 255, 255, 1)

    Lg.print("Current FPS: " .. tostring(love.timer.getFPS()), Lg.getWidth() - 100, 10)

    -- player resources
    Lg.print("Soldiers: " .. engine:getEntityCount("soldier"), 10, 10)
    Lg.print("Workers: " .. engine:getEntityCount("worker"), 110, 10)
    Lg.print("Scouts: " .. engine:getEntityCount("scout"), 220, 10)
    if PlayerColony then
        Lg.print("Food: " .. PlayerColony.nest:get("food").amount, 330, 10)
    end
end

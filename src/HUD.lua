local _GameData = require("GameData")

function Hud()
    -- hud draw
    Lg.setColor(0, 0, 0, .4)
    Lg.rectangle("fill", 0, 0, Lg.getWidth() * .80, 35)
    Lg.setColor(1, 1, 1, 1)

    Lg.print("FPS: " .. tostring(love.timer.getFPS()), Lg.getWidth() - 80, 10)

    -- Colony stats always visible (cached snapshot updated during battle)
    local col = _GameData.colony
    Lg.setColor(0.85, 0.50, 0.20, 1)
    Lg.print("Soldiers: " .. col.soldiers, 10, 10)
    Lg.setColor(0.30, 0.90, 0.30, 1)
    Lg.print("Workers: " .. col.workers, 130, 10)
    Lg.setColor(0.40, 0.80, 1.00, 1)
    Lg.print("Scouts: " .. col.scouts, 245, 10)
    Lg.setColor(1.00, 0.85, 0.20, 1)
    Lg.print("Food: " .. col.food, 345, 10)
    Lg.setColor(1, 1, 1, 1)

    -- Pioneer mode reminder
    if CurrentLevelMode == "fresh" and GameState == 1 then
        Lg.setColor(0.6, 0.95, 1, 0.85)
        Lg.print("Pioneer Colony  –  Build workers to gather food, then train an army.",
            10, Lg.getHeight() - 44)
        Lg.setColor(1, 1, 1, 1)
    end

    -- F5/F9 hint in game state
    if GameState == 1 then
        Lg.setColor(1, 1, 1, 0.35)
        Lg.print("[F5] Save  [F9] Load", Lg.getWidth() - 160, Lg.getHeight() - 22)
    end

    -- Notification overlay (screen-space, bottom-left stack)
    local notifs = _GameData.notifications
    local sw, sh = Lg.getWidth(), Lg.getHeight()
    local nw     = 380
    local nh     = 26
    local pad    = 4
    local baseY  = sh - 60
    for idx = #notifs, 1, -1 do
        local n     = notifs[idx]
        local age   = 1 - math.min(n.timer / 6, 1)
        local alpha = age < 0.15 and (age / 0.15)
            or n.timer < 1 and n.timer
            or 0.92
        local y     = baseY - ((#notifs - idx) * (nh + pad))

        -- Background pill
        Lg.setColor(0.05, 0.05, 0.05, alpha * 0.82)
        Lg.rectangle("fill", sw - nw - 12, y, nw, nh, 5, 5)
        -- Coloured left bar
        Lg.setColor(n.color[1], n.color[2], n.color[3], alpha)
        Lg.rectangle("fill", sw - nw - 12, y, 4, nh, 3, 3)
        -- Text
        Lg.setColor(1, 1, 1, alpha)
        Lg.print(n.text, sw - nw - 4, y + 6)
    end

    Lg.setColor(1, 1, 1, 1)
end

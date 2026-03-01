local Control  = {}
local GameData = require("GameData")
local Levels   = require("Levels")

-- Returns true when no rival (type == 2) ants are still alive
local function rivalsDefeated()
    for _, e in pairs(engine.entities) do
        if e.isAlive and e.type == 2 then
            return false
        end
    end
    return true
end

local function renderHUD()
    if PlayerColony then
        local nest = PlayerColony.nest
        local windowHeight = Lg.getHeight()
        -- make into objects and loop
        suit.layout:reset(20, windowHeight - 80)
        suit.layout:row(100, 30)
        if suit.Button("Worker", suit.layout:row()).hit then
            if nest:get("food").amount > WorkerPrice then
                nest:get("food").amount = nest:get("food").amount - WorkerPrice
                nest.ants.workers = nest.ants.workers + 1
            end
        end
        suit.layout:reset(140, windowHeight - 80)
        suit.layout:row(100, 30)
        if suit.Button("Soldier", suit.layout:row()).hit then
            if nest:get("food").amount > SoldierPrice then
                nest:get("food").amount = nest:get("food").amount - SoldierPrice
                nest.ants.soldiers = nest.ants.soldiers + 1
            end
        end
        suit.layout:reset(260, windowHeight - 80)
        suit.layout:row(100, 30)
        if suit.Button("Scout", suit.layout:row()).hit then
            if nest:get("food").amount > ScoutPrice then
                nest:get("food").amount = nest:get("food").amount - ScoutPrice
                nest.ants.scouts = nest.ants.scouts + 1
            end
        end
        suit.layout:reset(380, windowHeight - 80)
        suit.layout:row(100, 30)
        if suit.Button("World", suit.layout:row()).hit then
            -- Auto-conquer if rivals have been wiped out in this realm
            if CurrentLevelIdx and rivalsDefeated() then
                local ld = GameData.levels[CurrentLevelIdx]
                if ld and ld.status ~= "conquered" then
                    GameData.conquer(CurrentLevelIdx, Levels)
                end
            end
            GameState = 2
        end
    end
end

function Control.update(dt)
    local scrollSpeed = 1500
    local currentX, currentY = Cam:getPosition()
    if Lk.isDown("up") then
        Cam:setPosition(currentX, currentY - scrollSpeed * dt)
    end
    if Lk.isDown("left") then
        Cam:setPosition(currentX - scrollSpeed * dt, currentY)
    end
    if Lk.isDown("up") and Lk.isDown("left") then
        Cam:setPosition(currentX - scrollSpeed * dt, currentY - scrollSpeed * dt)
    end
    if Lk.isDown("right") then
        Cam:setPosition(currentX + scrollSpeed * dt, currentY)
    end
    if Lk.isDown("up") and Lk.isDown("right") then
        Cam:setPosition(currentX + scrollSpeed * dt, currentY - scrollSpeed * dt)
    end
    if Lk.isDown("down") then
        Cam:setPosition(currentX, currentY + scrollSpeed * dt)
    end
    if Lk.isDown("right") and Lk.isDown("down") then
        Cam:setPosition(currentX + scrollSpeed * dt, currentY + scrollSpeed * dt)
    end
    if Lk.isDown("left") and Lk.isDown("down") then
        Cam:setPosition(currentX - scrollSpeed * dt, currentY + scrollSpeed * dt)
    end

    renderHUD()
end

return Control

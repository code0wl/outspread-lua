local WorldMap   = class("WorldMap")
local Levels     = require "Levels"
local Colony     = require("entities.Colony")
local GameData   = require("GameData")
local SaveSystem = require("SaveSystem")

-- ─── Hill drawing ────────────────────────────────────────────────────
-- status: "undiscovered" | "scouted" | "accessible" | "conquered" | "contested"
local STATUS_COLORS = {
    undiscovered = {0.2, 0.2, 0.2},
    scouted      = {0.5, 0.4, 0.2},
    accessible   = {0.55, 0.27, 0.07},
    conquered    = {0.2, 0.6, 0.2},
    contested    = {0.8, 0.2, 0.1},
}

local function drawHill(x, y, w, h, status, hovered)
    local pr, pg, pb, pa = Lg.getColor()
    local col = STATUS_COLORS[status] or STATUS_COLORS.accessible

    -- Pulse red when contested
    if status == "contested" then
        local pulse = 0.5 + 0.5 * math.sin(love.timer.getTime() * 6)
        col = {0.6 + 0.3 * pulse, 0.1, 0.1}
    end

    Lg.setColor(col[1], col[2], col[3], 1)
    Lg.polygon("fill",
        x,           y + h,
        x + w,       y + h,
        x + w * 0.7, y,
        x + w * 0.3, y)

    -- Entrance hole
    Lg.setColor(0.08, 0.04, 0.0, 1)
    Lg.ellipse("fill", x + w * 0.5, y + h * 0.85, w * 0.18, h * 0.1)

    -- Undiscovered = fog silhouette + question mark
    if status == "undiscovered" then
        Lg.setColor(0.7, 0.7, 0.7, 0.5)
        Lg.print("?", x + w * 0.35, y + h * 0.15, 0, 2.5, 2.5)
        Lg.setColor(pr, pg, pb, pa)
        return
    end

    -- Conquered = green flag
    if status == "conquered" then
        Lg.setColor(0.2, 0.9, 0.2, 1)
        Lg.setLineWidth(2)
        Lg.line(x + w * 0.5, y, x + w * 0.5, y - h * 0.9)
        Lg.polygon("fill",
            x + w * 0.5,  y - h * 0.9,
            x + w * 0.85, y - h * 0.65,
            x + w * 0.5,  y - h * 0.4)
        Lg.setLineWidth(1)
    -- Scouted = tent/arrow indicator
    elseif status == "scouted" then
        Lg.setColor(0.9, 0.75, 0.3, 1)
        Lg.setLineWidth(1.5)
        Lg.line(x + w * 0.5, y - h * 0.6, x + w * 0.2, y, x + w * 0.8, y)
        Lg.setLineWidth(1)
    -- Accessible = black flag
    elseif status == "accessible" then
        Lg.setColor(0, 0, 0, 1)
        Lg.setLineWidth(2)
        Lg.line(x + w * 0.5, y, x + w * 0.5, y - h * 0.9)
        Lg.polygon("fill",
            x + w * 0.5,  y - h * 0.9,
            x + w * 0.85, y - h * 0.65,
            x + w * 0.5,  y - h * 0.4)
        Lg.setLineWidth(1)
    end

    -- Hover outline
    if hovered then
        Lg.setColor(1, 1, 1, 0.6)
        Lg.setLineWidth(2)
        Lg.polygon("line",
            x,           y + h,
            x + w,       y + h,
            x + w * 0.7, y,
            x + w * 0.3, y)
        Lg.setLineWidth(1)
    end

    Lg.setColor(pr, pg, pb, pa)
end

-- ─── World creation ──────────────────────────────────────────────────
-- mode:
--   "fresh"     - first entry: one pioneer scout, starter food, no rivals, no predators
--   "conquered" - re-entering a won realm: player nest only, no rivals
--   "normal"    - accessible realm: full setup with rivals and predators
local FRESH_FOOD   = 100
local FRESH_SCOUTS = 1    -- pioneer scout count

function WorldMap:create(level, mode)
    mode = mode or "normal"

    -- Starter food: fresh colonies get a small seed budget
    local startFood = (mode == "fresh") and FRESH_FOOD or level.colony.population

    PlayerColony = Colony:new({
        type       = level.colony.type,
        x          = level.location.x,
        y          = level.location.y,
        population = (mode == "fresh") and FRESH_SCOUTS or level.colony.population,
        width      = level.width,
        height     = level.height,
    })
    -- Override the nest's starting food to our chosen amount
    PlayerColony.nest:get("food").amount = startFood

    if mode == "fresh" then
        -- Pioneer mode: no auto-built army, only the one scout in the queue.
        PlayerColony.nest.ants = { soldiers = 0, workers = 0, scouts = FRESH_SCOUTS }
        GameData.addNotification(
            "Scout establishing new colony in " .. (level.name or "Realm") .. ".",
            {0.6, 0.9, 1}
        )
    end

    -- Spawn rivals unless conquered or fresh
    if mode == "normal" and level.rivals and level.rivals.population then
        local rival = level.rivals
        Colony:new({
            type       = rival.type,
            x          = rival.x,
            y          = rival.y,
            population = rival.population,
            width      = level.width,
            height     = level.height,
        })
    end

    -- Predators always present (except fresh first-entry, give the queen a head-start)
    if mode ~= "fresh" then
        for _, predator in ipairs(level.predators) do
            predator.type:new({x = predator.x, y = predator.y})
        end
    end
end

-- ─── Small action button (world-space) ───────────────────────────────
-- Fires once per click (tracks prev mouse state to avoid repeat-fire).
local _prevMouseDown = false
local _mouseDown     = false
local _clickFired    = false  -- only one button may consume the click per frame

local function actionButton(label, x, y, w, h)
    local mx, my = Cam:toWorld(Lm.getPosition())
    local hot = mx >= x and mx < x + w and my >= y and my < y + h
    Lg.setColor(hot and {0.9, 0.8, 0.1, 1} or {0.15, 0.13, 0.04, 0.88})
    Lg.rectangle("fill", x, y, w, h, 4, 4)
    Lg.setColor(0, 0, 0, 0.9)
    Lg.rectangle("line", x, y, w, h, 4, 4)
    Lg.setColor(hot and {0, 0, 0, 1} or {1, 1, 0.85, 1})
    Lg.print(label, x + 6, y + 5)
    Lg.setColor(1, 1, 1, 1)
    -- Fire only on the transition from not-held to held
    local clicked = hot and _mouseDown and not _prevMouseDown and not _clickFired
    if clicked then _clickFired = true end
    return clicked
end

-- ─── Draw ─────────────────────────────────────────────────────────────
function WorldMap:draw()
    local mouseX, mouseY   = Lm.getPosition()
    local mouseWX, mouseWY = Cam:toWorld(mouseX, mouseY)

    -- Per-frame click tracking (edge detection: down this frame, not last frame)
    _mouseDown     = love.mouse.isDown(1)
    _clickFired    = false

    Lg.draw(WorldMapBackground, 0, 0)

    for i, level in ipairs(Levels) do
        local ld = GameData.levels[i]
        if not ld then goto continue end

        local status = ld.status
        local size   = level.colony.population / 10
        local lx, ly = level.location.x, level.location.y
        local w, h   = size, size

        local hovered = mouseWX >= lx and mouseWY >= ly
                     and mouseWX < lx + w * 2 and mouseWY < ly + h * 2

        local drawW = hovered and (w + 5) or w
        local drawH = hovered and (h + 5) or h

        drawHill(lx, ly, drawW, drawH, status, hovered)

        -- Name label below the hill
        if status ~= "undiscovered" then
            Lg.setColor(1, 1, 0.8, 0.9)
            Lg.print(level.name or ("Realm " .. i), lx, ly + drawH + 6)
        end

        -- Scout expedition progress bar + send-more button
        if ld.scoutTimer > 0 and ld.scoutBaseTime and ld.scoutBaseTime > 0 then
            local frac = math.max(0, math.min(1, 1 - ld.scoutTimer / ld.scoutBaseTime))
            local barW = drawW
            Lg.setColor(0.1, 0.1, 0.1, 0.7)
            Lg.rectangle("fill", lx, ly - 14, barW, 7, 2)
            Lg.setColor(0.4, 0.9, 1, 1)
            Lg.rectangle("fill", lx, ly - 14, barW * frac, 7, 2)
            local eta = math.ceil(ld.scoutTimer)
            Lg.setColor(1, 1, 1, 0.9)
            Lg.print(
                (ld.scoutCount or 1) .. " scout(s) en route  ~" .. eta .. "s",
                lx, ly - 28
            )
            -- Button to reinforce the expedition with another scout
            if hovered and actionButton("+Scout", lx + barW + 6, ly - 17, 72, 18) then
                GameData.addScout(i)
            end
        end

        -- Hover action buttons
        if hovered then
            local btnY = ly + drawH + 24

            if status == "scouted" and ld.scoutTimer <= 0 then
                if actionButton("Dispatch Scout", lx, btnY, 118, 22) then
                    GameData.dispatchScout(i)
                end

            elseif status == "contested" then
                if actionButton("Defend!", lx, btnY, 80, 22) then
                    GameData.dismissContest(i)
                end

            elseif status == "accessible" or status == "conquered" then
                local ld       = GameData.levels[i]
                local isFirst  = not (ld and ld.entered)
                local isCon    = (status == "conquered")
                local btnLabel = isFirst and "Settle Realm" or "Enter Realm"
                if actionButton(btnLabel, lx, btnY, 108, 22) then
                    local mode = isCon and "conquered"
                               or isFirst and "fresh"
                               or "normal"
                    CurrentLevelIdx  = i
                    CurrentLevelMode = mode
                    GameData.markEntered(i)
                    self:create(level, mode)
                    GameState = 1
                    BackgroundImage = level.background
                end
            end
        end

        ::continue::
    end

    -- Save / Load buttons (drawn in world-space via camera inverse)
    local sw, sh   = Lg.getWidth(), Lg.getHeight()
    local bwx, bwy = Cam:toWorld(sw - 225, sh - 44)
    if actionButton("[F5] Save", bwx,       bwy, 100, 26) then
        SaveSystem.save(GameData)
    end
    if actionButton("[F9] Load", bwx + 110, bwy, 100, 26) then
        SaveSystem.load(GameData)
    end

    -- Store state for next frame's edge detection
    _prevMouseDown = _mouseDown
end

return WorldMap

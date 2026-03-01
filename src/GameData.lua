-- GameData: single-source-of-truth for persistent 4X progression.
-- Level statuses:
--   "undiscovered"  - fog of war, position unknown
--   "scouted"       - visible on map, can dispatch an expedition
--   "accessible"    - expedition arrived, entereable
--   "conquered"     - player cleared the level
--   "contested"     - rivals detected at a conquered hill, needs attention
--
-- Levels are assumed in a loose chain: i is adjacent to i-1 and i+1.
-- Level 1 always starts as "accessible" (the home hill).

local GameData          = {}

-- ─── Level state ────────────────────────────────────────────────────
-- Populated lazily the first time it is needed (after Levels module loads).
GameData.levels         = {}

-- Timers (seconds)
local SCOUT_TRAVEL_TIME = 60    -- base travel time for ONE scout alone
local SCOUT_DEATH_RATE  = 0.006 -- per-scout per-second mortality probability
local CONTEST_INTERVAL  = 90    -- conquered level gets contested after this many seconds
local CONTEST_RESOLVE   = 30    -- auto-resolve contest if player ignores it

-- ─── Notifications ──────────────────────────────────────────────────
GameData.notifications  = {}
local MAX_NOTIFS        = 6
local NOTIF_LIFE        = 6 -- seconds each notification is visible

function GameData.addNotification(text, color)
    -- Drop oldest if queue is full
    if #GameData.notifications >= MAX_NOTIFS then
        table.remove(GameData.notifications, 1)
    end
    table.insert(GameData.notifications, {
        text  = text,
        timer = NOTIF_LIFE,
        color = color or { 1, 1, 0.4 },
    })
end

-- ─── Initialise ─────────────────────────────────────────────────────
function GameData.init(levels)
    -- Only initialise once; preserve state on re-init calls
    for i, level in ipairs(levels) do
        if not GameData.levels[i] then
            GameData.levels[i] = {
                status        = level.initialStatus or (i == 1 and "accessible" or "undiscovered"),
                scoutTimer    = 0, -- countdown while expedition is travelling
                scoutCount    = 0, -- number of scouts currently en route
                scoutBaseTime = 0, -- original travel time when expedition started (for progress bar)
                contestTimer  = 0, -- countdown to next contest event
                -- Level 1 (home warren) is treated as already settled
                entered       = (i == 1),
            }
        end
    end
    -- Reveal neighbours of already-accessible/conquered levels
    GameData._refreshScouted(levels)
end

-- Any level adjacent to an accessible/conquered level becomes "scouted"
function GameData._refreshScouted(levels)
    for i = 1, #levels do
        local s = GameData.levels[i].status
        if s == "accessible" or s == "conquered" then
            for _, ni in ipairs({ i - 1, i + 1 }) do
                if levels[ni] and GameData.levels[ni].status == "undiscovered" then
                    GameData.levels[ni].status = "scouted"
                end
            end
        end
    end
end

-- ─── Update (call every frame from love.update) ──────────────────────
function GameData.update(dt, levels)
    -- Notification timers
    local i = 1
    while i <= #GameData.notifications do
        GameData.notifications[i].timer = GameData.notifications[i].timer - dt
        if GameData.notifications[i].timer <= 0 then
            table.remove(GameData.notifications, i)
        else
            i = i + 1
        end
    end

    for idx, ld in ipairs(GameData.levels) do
        -- Scout expedition: deaths + countdown
        if ld.scoutTimer > 0 and ld.scoutCount > 0 then
            -- Each active scout has a small per-second chance of perishing
            local deaths = 0
            for _ = 1, ld.scoutCount do
                if math.random() < SCOUT_DEATH_RATE * dt then
                    deaths = deaths + 1
                end
            end
            if deaths > 0 then
                ld.scoutCount = ld.scoutCount - deaths
                if ld.scoutCount <= 0 then
                    -- Expedition wiped out — abort
                    ld.scoutCount    = 0
                    ld.scoutTimer    = 0
                    ld.scoutBaseTime = 0
                    GameData.addNotification(
                        "All scouts lost en route to Realm " .. idx .. "! Expedition failed.",
                        { 1, 0.2, 0.1 }
                    )
                else
                    GameData.addNotification(
                        deaths .. " scout(s) lost en route to Realm " .. idx
                        .. ". (" .. ld.scoutCount .. " remaining)",
                        { 1, 0.55, 0.2 }
                    )
                end
            end

            if ld.scoutTimer > 0 and ld.scoutCount > 0 then
                ld.scoutTimer = ld.scoutTimer - dt
                if ld.scoutTimer <= 0 then
                    ld.scoutTimer = 0
                    ld.status     = "accessible"
                    GameData.addNotification(
                        ld.scoutCount .. " scout(s) reached Realm " .. idx .. "! Now accessible.",
                        { 0.4, 1, 0.5 }
                    )
                    ld.scoutCount    = 0
                    ld.scoutBaseTime = 0
                    GameData._refreshScouted(levels)
                end
            end
        end

        -- Contest countdown on conquered levels
        if ld.status == "conquered" then
            ld.contestTimer = ld.contestTimer - dt
            if ld.contestTimer <= 0 then
                ld.contestTimer = CONTEST_INTERVAL + math.random(-15, 15)
                -- Only contest levels that have a rivals entry
                if levels[idx] and levels[idx].rivals then
                    ld.status = "contested"
                    GameData.addNotification(
                        "⚠  Rival scouts at Realm " .. idx .. "! Respond!",
                        { 1, 0.3, 0.2 }
                    )
                end
            end
        end

        -- Auto-resolve contest after CONTEST_RESOLVE seconds
        if ld.status == "contested" then
            ld.contestTimer = ld.contestTimer - dt
            if ld.contestTimer <= 0 then
                -- Player ignored it: realm is lost back to rivals
                ld.status = "accessible"
                GameData.addNotification(
                    "Realm " .. idx .. " overrun! Retake it.",
                    { 1, 0.2, 0.2 }
                )
                ld.contestTimer = CONTEST_INTERVAL + math.random(-15, 15)
            end
        end
    end
end

-- ─── Actions ────────────────────────────────────────────────────────
-- Call when player clicks "Dispatch Scout" on a scouted level (first scout)
function GameData.dispatchScout(levelIdx)
    local ld = GameData.levels[levelIdx]
    if ld and ld.status == "scouted" and ld.scoutTimer <= 0 then
        ld.scoutCount    = 1
        ld.scoutTimer    = SCOUT_TRAVEL_TIME
        ld.scoutBaseTime = SCOUT_TRAVEL_TIME
        GameData.addNotification(
            "Scout dispatched to Realm " .. levelIdx .. ".  ETA ~" .. math.ceil(SCOUT_TRAVEL_TIME) .. "s.",
            { 0.6, 0.9, 1 }
        )
    end
end

-- Call when player sends an additional scout to an ongoing expedition
-- Each extra scout proportionally reduces remaining travel time.
function GameData.addScout(levelIdx)
    local ld = GameData.levels[levelIdx]
    if ld and ld.scoutTimer > 0 and ld.scoutCount > 0 then
        local old     = ld.scoutCount
        ld.scoutCount = old + 1
        -- Speed scales with count: new_time = old_time * old / new
        ld.scoutTimer = ld.scoutTimer * (old / ld.scoutCount)
        local eta     = math.ceil(ld.scoutTimer)
        GameData.addNotification(
            "Extra scout en route to Realm " .. levelIdx
            .. ". (" .. ld.scoutCount .. " scouts, ETA ~" .. eta .. "s)",
            { 0.6, 0.9, 1 }
        )
    end
end

-- Call when player wins a battle in a level
function GameData.conquer(levelIdx, levels)
    local ld = GameData.levels[levelIdx]
    if ld then
        ld.status = "conquered"
        ld.contestTimer = CONTEST_INTERVAL + math.random(-15, 15)
        GameData.addNotification(
            "Realm " .. levelIdx .. " conquered! Glory to the colony.",
            { 1, 0.85, 0.2 }
        )
        GameData._refreshScouted(levels)
    end
end

-- Dismiss a contest — player acknowledged, sends defenders
function GameData.dismissContest(levelIdx)
    local ld = GameData.levels[levelIdx]
    if ld and ld.status == "contested" then
        ld.status = "conquered"
        ld.contestTimer = CONTEST_INTERVAL + math.random(-15, 15)
        GameData.addNotification(
            "Defenders repelled rivals at Realm " .. levelIdx .. ".",
            { 0.4, 1, 0.5 }
        )
    end
end

-- Mark that the player has physically entered a level for the first time
function GameData.markEntered(levelIdx)
    local ld = GameData.levels[levelIdx]
    if ld then ld.entered = true end
end

return GameData

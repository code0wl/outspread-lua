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

-- ─── Colony snapshot (persists to worldmap so HUD always shows) ────
GameData.colony         = { soldiers = 0, workers = 0, scouts = 0, food = 0 }

function GameData.updateColonySnapshot()
    if not PlayerColony then return end
    GameData.colony.soldiers = engine:getEntityCount("soldier")
    GameData.colony.workers  = engine:getEntityCount("worker")
    GameData.colony.scouts   = engine:getEntityCount("scout")
    local nest               = PlayerColony.nest
    if nest and nest:has("food") then
        GameData.colony.food = math.floor(nest:get("food").amount)
    end
end

-- ─── Terrain decoration ──────────────────────────────────────────────
-- Deterministic per-level; generated once on first visit/load using a
-- seeded RNG so rocks/bushes are always in the same spots.
local DECOR_ROCKS  = 40
local DECOR_BUSHES = 22

function GameData.generateDecor(levelIdx)
    local ld = GameData.levels[levelIdx]
    if not ld or ld.decor then return end
    local rng    = love.math.newRandomGenerator(levelIdx * 31337 + 99991)
    local decor  = {}
    local MARGIN = 120

    local function rp()
        return rng:random(MARGIN, GlobalWidth - MARGIN),
            rng:random(MARGIN, GlobalHeight - MARGIN)
    end

    -- Rocks
    for _ = 1, DECOR_ROCKS do
        local x, y = rp()
        local w    = rng:random(18, 70)
        local h    = rng:random(12, 42)
        local g    = 0.28 + rng:random() * 0.34
        table.insert(decor, {
            kind  = "rock",
            x     = x - w * 0.5,
            y     = y - h * 0.5,
            w     = w,
            h     = h,
            rot   = rng:random() * math.pi,
            color = { g * 0.95, g * 0.88, g * 0.75 },
        })
    end

    -- Sparse vegetation
    for _ = 1, DECOR_BUSHES do
        local x, y = rp()
        local r    = rng:random(8, 26)
        local gv   = 0.15 + rng:random() * 0.22
        table.insert(decor, {
            kind  = "bush",
            x     = x,
            y     = y,
            r     = r,
            color = { 0.06 + rng:random() * 0.04, gv, 0.03 },
        })
    end

    ld.decor = decor
end

-- ─── Notifications ──────────────────────────────────────────────────
GameData.notifications = {}
local MAX_NOTIFS       = 6
local NOTIF_LIFE       = 6  -- seconds each notification is visible

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
                scoutTimer    = 0,
                scoutCount    = 0,
                scoutBaseTime = 0,
                contestTimer  = 0,
                entered       = (i == 1), -- true = "Enter Realm" label (home pre-set)
                initialized   = false,    -- true only after create() has actually run
                pendingBurrow = nil,
            }
        end
        -- Generate terrain decorations (safe to call multiple times)
        GameData.generateDecor(i)
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
                    -- Queue a rival burrow for when player next enters this level
                    ld.pendingBurrow = {
                        x      = math.random(400, GlobalWidth - 400),
                        y      = math.random(300, GlobalHeight - 300),
                        delay  = 45, -- seconds before ants pour out
                        rivals = levels[idx].rivals,
                    }
                    GameData.addNotification(
                        "⚠  Rival scouts at Realm " .. idx .. "! A burrow is being dug!",
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

-- Mark that the colony has been initialised in this level (create() was run)
function GameData.markInitialized(levelIdx)
    local ld = GameData.levels[levelIdx]
    if ld then ld.initialized = true end
end

return GameData

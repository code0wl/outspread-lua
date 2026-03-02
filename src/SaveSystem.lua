-- SaveSystem: serialise/deserialise GameData to love.filesystem.
-- Format: plain Lua table string (no external JSON lib required).

local SaveSystem = {}
local SAVE_FILE = "outspread_save.lua"

-- ─── Serialiser (minimal, handles nested tables, strings, numbers, booleans) ─
local function serialize(val, indent)
    indent = indent or ""
    local t = type(val)
    if t == "number" then
        return tostring(val)
    elseif t == "boolean" then
        return tostring(val)
    elseif t == "string" then
        return string.format("%q", val)
    elseif t == "table" then
        local parts = {}
        local inner = indent .. "  "
        for k, v in pairs(val) do
            local key = type(k) == "string"
                and ("[" .. string.format("%q", k) .. "]")
                or ("[" .. tostring(k) .. "]")
            table.insert(parts, inner .. key .. " = " .. serialize(v, inner))
        end
        return "{\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "}"
    end
    return "nil"
end

-- ─── Save ────────────────────────────────────────────────────────────
function SaveSystem.save(GameData)
    local levels = {}
    for i, ld in ipairs(GameData.levels) do
        levels[i] = {
            status        = ld.status,
            scoutTimer    = ld.scoutTimer,
            scoutCount    = ld.scoutCount,
            scoutBaseTime = ld.scoutBaseTime,
            contestTimer  = ld.contestTimer,
            entered       = ld.entered,
            initialized   = ld.initialized,
            pendingBurrow = ld.pendingBurrow,
        }
    end

    local playerFood = 0
    if PlayerColony and PlayerColony.nest then
        playerFood = PlayerColony.nest:get("food").amount
    end

    local data = {
        levels     = levels,
        playerFood = playerFood,
        savedAt    = os.date("%Y-%m-%d %H:%M"),
    }

    local str = "return " .. serialize(data)
    local ok, err = love.filesystem.write(SAVE_FILE, str)
    if ok then
        GameData.addNotification("Game saved. (" .. data.savedAt .. ")", { 0.5, 1, 0.5 })
    else
        GameData.addNotification("Save FAILED: " .. tostring(err), { 1, 0.3, 0.3 })
    end
end

-- ─── Load ────────────────────────────────────────────────────────────
function SaveSystem.load(GameData)
    if not love.filesystem.getInfo(SAVE_FILE) then
        GameData.addNotification("No save file found.", { 1, 0.7, 0.3 })
        return false
    end

    local chunk, err = love.filesystem.load(SAVE_FILE)
    if not chunk then
        GameData.addNotification("Load FAILED: " .. tostring(err), { 1, 0.3, 0.3 })
        return false
    end

    local ok, data = pcall(chunk)
    if not ok or type(data) ~= "table" then
        GameData.addNotification("Save file corrupted.", { 1, 0.3, 0.3 })
        return false
    end

    -- Restore level states
    for i, ld in ipairs(data.levels or {}) do
        if GameData.levels[i] then
            GameData.levels[i].status        = ld.status or "undiscovered"
            GameData.levels[i].scoutTimer    = ld.scoutTimer or 0
            GameData.levels[i].scoutCount    = ld.scoutCount or 0
            GameData.levels[i].scoutBaseTime = ld.scoutBaseTime or 0
            GameData.levels[i].contestTimer  = ld.contestTimer or 0
            GameData.levels[i].entered       = ld.entered or false
            GameData.levels[i].initialized   = ld.initialized or false
            GameData.levels[i].pendingBurrow = ld.pendingBurrow or nil
        end
    end

    -- Restore player food if colony is active
    if data.playerFood and PlayerColony and PlayerColony.nest then
        PlayerColony.nest:get("food").amount = data.playerFood
    end

    GameData.addNotification(
        "Save loaded. (" .. tostring(data.savedAt or "?") .. ")",
        { 0.5, 1, 0.5 }
    )
    return true
end

return SaveSystem

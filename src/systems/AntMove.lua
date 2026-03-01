-- move System
local AntMoveSystem = class("AntMoveSystem", System)

function AntMoveSystem:requires()
    return { "ant" }
end

-- ─── Steering constants ───────────────────────────────────────────────
local TURN_RATE        = 4.5  -- max radians/sec the ant can turn (curved turns)
local WANDER_FREQ      = 0.7  -- Hz of the wander oscillation
local WANDER_AMP       = 0.18 -- radians of swing while free-roaming (subtle drift)
local WANDER_AMP_SCENT = 0.07 -- barely-there sway while on a scent trail
local ALIGN_RADIUS     = 38   -- px: look for neighbours to loosely align with
local ALIGN_STRENGTH   = 0.08 -- gentle nudge toward neighbour heading
local SPREAD_HALF      = 10   -- ± lateral pixel spread per ant around scent path

-- Shortest signed difference between two angles
local function angleDiff(a, b)
    local d = (b - a) % (math.pi * 2)
    if d > math.pi then d = d - math.pi * 2 end
    return d
end

-- Step heading at most maxStep radians toward desired angle
local function turnToward(current, desired, maxStep)
    local diff = angleDiff(current, desired)
    if math.abs(diff) <= maxStep then return desired end
    return current + (diff > 0 and maxStep or -maxStep)
end

local antFilter = function(ant, other)
    local antAlive = ant.isAlive
    local otherAlive = other.isAlive
    local otherDead = not other.isAlive

    if antAlive and otherAlive then
        if ant.type ~= other.type then
            ant:attack(other)
            ant.scentlocation = other
            return "bounce"
        elseif ant.scentlocation and not other.scentlocation then
            other.scentlocation = ant.scentlocation
            return nil
        end
    end

    --  handle dead vars
    if not ant.hasFood and antAlive and otherDead then
        -- Spider body parts require several ants nearby before any one can lift
        if other:has("bodyPart") then
            local required = other:get("bodyPart").requiredCarriers
            local nearby   = world:queryRect(
                other:get("position").x - 25,
                other:get("position").y - 25,
                50, 50)
            local count    = 0
            for _, item in ipairs(nearby) do
                if item ~= ant and item.isAlive and item.type == ant.type then
                    count = count + 1
                end
            end
            if count < required - 1 then
                return nil -- not enough ants yet — mill around and wait
            end
            ant.carryType = "spiderPart"
        else
            ant.carryType = other:has("ant") and "body" or "food"
        end

        ant:carry(other)
        ant.scentlocation = other
        ant.hasFood = true
        return nil
    end
end

function AntMoveSystem:update(dt)
    local now = love.timer.getTime()

    for _, entity in pairs(self.targets) do
        if entity.isAlive and not entity.player then
            local position = entity:get("position")
            local velocity = entity:get("velocity")
            local nestPosition = entity.nest:get("position")

            -- ── Lazy-init per-ant steering state ──────────────────────────
            if not entity.heading then
                entity.heading     = math.random() * math.pi * 2
                entity.wanderPhase = math.random() * math.pi * 2
                -- stable ±1 lateral sign for spreading alongside trail-mates
                entity.spreadSign  = ((entity.id or math.random(0, 1)) % 2 == 0) and 1 or -1
            end

            entity.TimePassedAnt = entity.TimePassedAnt + dt

            -- ── Target logic (unchanged gameplay) ─────────────────────────
            if entity.hasFood then
                entity.target = nestPosition
            end

            if entity.hasFood and
                util.distanceBetween(position.x, position.y, nestPosition.x, nestPosition.y) <
                entity.nest:get("dimension").width
            then
                entity.nest:receiveFood(entity.carryCapacity)
                entity.hasFood   = false
                entity.carryType = nil
            end

            if entity.scentlocation and not entity.hasFood then
                entity.target = entity.scentlocation:get("position")
            end

            if not entity.scentlocation and not entity.hasFood and
                entity.TimePassedAnt > math.random(2, 4)
            then
                entity.TimePassedAnt = 0
                entity.target = Components.Position(util.travelRandomly())
            end

            if not entity.scentlocation and not entity.hasFood and
                util.distanceBetween(position.x, position.y, entity.target.x, entity.target.y) < 3
            then
                entity.target = Components.Position(util.travelRandomly())
            end

            if entity.scentlocation and entity.scentlocation:get("food").amount < 1 and not entity.hasFood then
                entity.scentlocation = nil
            end

            if util.isOutOfBounds(position.x, position.y) then
                entity.target = nestPosition
            end

            -- ── Desired angle toward target ───────────────────────────────
            local tx, ty = entity.target.x, entity.target.y

            -- Scent-following ants spread laterally so they form a living
            -- column rather than a single pixel stack.
            if entity.scentlocation and not entity.hasFood then
                local dx = tx - position.x
                local dy = ty - position.y
                local len = math.sqrt(dx * dx + dy * dy)
                if len > 1 then
                    -- perpendicular to the direct line
                    local px = -dy / len
                    local py = dx / len
                    tx = tx + px * entity.spreadSign * SPREAD_HALF
                    ty = ty + py * entity.spreadSign * SPREAD_HALF
                end
            end

            local desiredAngle = math.atan2(ty - position.y, tx - position.x)

            -- ── Neighbour alignment (boid-style) ──────────────────────────
            -- Loosely steer toward the average heading of nearby same-colony ants.
            local neighbours = world:queryRect(
                position.x - ALIGN_RADIUS,
                position.y - ALIGN_RADIUS,
                ALIGN_RADIUS * 2, ALIGN_RADIUS * 2)
            local sinSum, cosSum, count = 0, 0, 0
            for _, nb in ipairs(neighbours) do
                if nb ~= entity and nb.isAlive and nb.type == entity.type and nb.heading then
                    sinSum = sinSum + math.sin(nb.heading)
                    cosSum = cosSum + math.cos(nb.heading)
                    count  = count + 1
                end
            end
            if count > 0 then
                local avgHeading = math.atan2(sinSum / count, cosSum / count)
                local alignNudge = angleDiff(desiredAngle, avgHeading) * ALIGN_STRENGTH
                desiredAngle     = desiredAngle + alignNudge
            end

            -- ── Wander offset (slow sinusoidal drift) ─────────────────────
            local wanderAmp        = (entity.scentlocation or entity.hasFood)
                and WANDER_AMP_SCENT or WANDER_AMP
            local wander           = math.sin(now * WANDER_FREQ + entity.wanderPhase) * wanderAmp

            -- ── Curved turn — clamp rotation rate ─────────────────────────
            entity.heading         = turnToward(entity.heading, desiredAngle + wander, TURN_RATE * dt)

            -- ── Advance along current heading ─────────────────────────────
            local speed            = velocity.speed
            local newX             = position.x + math.cos(entity.heading) * speed * dt
            local newY             = position.y + math.sin(entity.heading) * speed * dt

            local finalX, finalY   = world:move(entity, newX, newY, antFilter)
            position.x, position.y = finalX, finalY
        end
    end
end

return AntMoveSystem

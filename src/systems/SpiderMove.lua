-- move System
local SpiderMoveSystem = class("SpiderMoveSystem", System)

function SpiderMoveSystem:requires() return { "spider" } end

-- Off-screen escape points at each edge
local function fleeTarget()
    local edge = math.random(1, 4)
    if edge == 1 then return -200, math.random(0, GlobalHeight) end
    if edge == 2 then return GlobalWidth + 200, math.random(0, GlobalHeight) end
    if edge == 3 then return math.random(0, GlobalWidth), -200 end
    return math.random(0, GlobalWidth), GlobalHeight + 200
end

local spiderFiler = function(item, other)
    -- Rocks are plain tables (no ECS methods) — slide around them
    if other.isRock then return "slide" end

    local itemAlive  = item.isAlive
    local otherAlive = other.isAlive

    if itemAlive and otherAlive then
        if item.isFleeing then return 'cross' end -- don't fight while fleeing
        -- Only attack actual actors (must have health)
        if not other:has("health") then return 'cross' end
        item:attack(other)
        return 'bounce'
    end

    if itemAlive and not otherAlive then
        -- Only eat dead actors (skip food pellets, body parts, etc.)
        if not other:has("health") then return 'cross' end
        item:eat(other)
        return nil
    end
end

function SpiderMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        if entity.isAlive then
            local position = entity:get("position")
            local velocity = entity:get("velocity")

            -- Initialise persistent state on first tick
            if not entity.homeX then
                entity.homeX          = position.x
                entity.homeY          = position.y
                entity.isFleeing      = false
                entity.isReturning    = false
                entity.overwhelmTimer = 0
                entity.fleeingTimer   = 0
                entity.normalSpeed    = velocity.speed
            end

            -- ── OVERWHELM CHECK ──────────────────────────────────────────────
            if not entity.isFleeing and not entity.isReturning then
                -- Count living enemies within 120px
                local items, len = world:queryRect(
                    position.x - 60, position.y - 60, 120, 120)
                local nearbyEnemies = 0
                for i = 1, len do
                    if items[i] ~= entity and items[i].isAlive then
                        nearbyEnemies = nearbyEnemies + 1
                    end
                end

                if nearbyEnemies >= 5 then
                    entity.overwhelmTimer = entity.overwhelmTimer + dt
                    if entity.overwhelmTimer >= math.random(3, 7) then
                        -- Trigger flee
                        entity.isFleeing      = true
                        entity.overwhelmTimer = 0
                        entity.fleeingTimer   = math.random(15, 30)
                        velocity.speed        = entity.normalSpeed * 2.2
                        local fx, fy          = fleeTarget()
                        entity.target         = Components.Position(fx, fy)
                    end
                else
                    entity.overwhelmTimer = math.max(0, entity.overwhelmTimer - dt)
                end
            end

            -- ── FLEEING ──────────────────────────────────────────────────────
            if entity.isFleeing then
                entity.fleeingTimer = entity.fleeingTimer - dt

                -- Once enough time has passed (or spider is off-screen), start return
                local offScreen = util.isOutOfBounds(position.x, position.y)
                if entity.fleeingTimer <= 0 or (offScreen and entity.fleeingTimer < 20) then
                    entity.isFleeing   = false
                    entity.isReturning = true
                    velocity.speed     = entity.normalSpeed * 1.4
                    entity.target      = Components.Position(entity.homeX, entity.homeY)
                end

                -- ── RETURNING ────────────────────────────────────────────────────
            elseif entity.isReturning then
                entity.target = Components.Position(entity.homeX, entity.homeY)
                if util.distanceBetween(position.x, position.y, entity.homeX, entity.homeY) < 80 then
                    entity.isReturning      = false
                    velocity.speed          = entity.normalSpeed
                    entity.TimePassedSpider = 0
                end

                -- ── NORMAL PATROL ─────────────────────────────────────────────
            else
                entity.TimePassedSpider = entity.TimePassedSpider + 1 * dt

                if entity.TimePassedSpider > math.random(6, 10) then
                    entity.TimePassedSpider = 0
                    entity.target = Components.Position(
                        util.travelNear(entity.homeX, entity.homeY, 600))
                end

                if util.distanceBetween(position.x, position.y, entity.homeX, entity.homeY) > 650 then
                    entity.target = Components.Position(entity.homeX, entity.homeY)
                end

                if util.distanceBetween(position.x, position.y,
                        entity.target.x, entity.target.y) < 3 then
                    entity.target = Components.Position(
                        util.travelNear(entity.homeX, entity.homeY, 600))
                end
            end

            -- ── MOVEMENT ─────────────────────────────────────────────────────
            local nextX, nextY = world:move(entity, position.x, position.y, spiderFiler)
            position.x, position.y = util.setDirection(
                nextX, nextY, velocity.speed, entity.target, dt)
        end
    end
end

return SpiderMoveSystem

local BodyPart     = require("entities.BodyPart")
local DeathEffect  = require("entities.DeathEffect")
local FoodPellet   = require("entities.FoodPellet")

-- move System
local HealthSystem = class("HealthSystem", System)

function HealthSystem:requires() return { "health", "position", "food" } end

-- Body-part offsets that approximate the spider's visible limbs / thorax
local SPIDER_PARTS = {
    { dx = 0,   dy = 0,   food = 40, r = 8, carriers = 4 }, -- thorax (heaviest)
    { dx = 60,  dy = -30, food = 20, r = 5, carriers = 2 }, -- right front
    { dx = -60, dy = -30, food = 20, r = 5, carriers = 2 }, -- left  front
    { dx = 70,  dy = 30,  food = 20, r = 5, carriers = 2 }, -- right rear
    { dx = -70, dy = 30,  food = 20, r = 5, carriers = 2 }, -- left  rear
}

function HealthSystem:update()
    for _, entity in pairs(self.targets) do
        local health = entity:get("health")
        local food   = entity:get("food")

        if health.amount < 1 then
            entity.isAlive = false

            if not entity.deathExploded then
                entity.deathExploded = true
                local pos = entity:get("position")
                local isSpider = entity:has("spider")

                -- visual burst
                local preset = isSpider and "spider" or "ant"
                DeathEffect:new(pos.x, pos.y, preset)

                -- pickable food pellets scattered around the corpse
                local pelletCount   = isSpider and 35 or 4
                local spread        = isSpider and 90 or 20
                local foodPerPellet = isSpider and 3 or 1
                local pelletRadius  = isSpider and 4 or 2
                local pelletColour  = { 1, 0.8, 0.15 }
                for _ = 1, pelletCount do
                    FoodPellet:new({
                        x      = pos.x,
                        y      = pos.y,
                        spread = spread,
                        food   = foodPerPellet,
                        radius = pelletRadius,
                        colour = pelletColour,
                    })
                end
            end

            -- Spawn spider body parts exactly once when the spider first dies
            if entity:has("spider") and not entity.partsSpawned then
                entity.partsSpawned = true
                local pos = entity:get("position")
                for _, p in ipairs(SPIDER_PARTS) do
                    BodyPart:new({
                        x                = pos.x + p.dx,
                        y                = pos.y + p.dy,
                        food             = p.food,
                        radius           = p.r,
                        requiredCarriers = p.carriers,
                    })
                end
            end
        end

        if food.amount < 1 then
            engine:removeEntity(entity)
            if world:hasItem(entity) then world:remove(entity) end
        end
    end
end

return HealthSystem

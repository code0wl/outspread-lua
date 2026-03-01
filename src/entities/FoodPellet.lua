-- A single pickable food pellet scattered from a death explosion.
-- Ants detect it via bump collision and carry it back as carryType="food".
local FoodPellet = class("FoodPellet", Entity)

function FoodPellet:initialize(config)
    Entity.initialize(self)

    -- isAlive intentionally nil so antFilter treats it as dead/pickup-able

    local spread = config.spread or 60
    local angle  = math.random() * math.pi * 2
    local dist   = math.random() * spread
    local x      = config.x + math.cos(angle) * dist
    local y      = config.y + math.sin(angle) * dist

    local r      = config.radius or 3
    local c      = config.colour or { 1, 0.8, 0.15 }

    self:add(Components.Position(x, y))
    self:add(Components.Food(config.food or 2))
    self:add(Components.FoodPellet(r, c))

    engine:addEntity(self)
    world:add(self, x, y, r * 2, r * 2)
end

return FoodPellet

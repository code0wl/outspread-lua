-- Glowing food pellet: small diamond shape, warm colour tinted per entity
local ParticleCanvas = nil

local function getParticleCanvas()
    if not ParticleCanvas then
        local sz = 10
        ParticleCanvas = Lg.newCanvas(sz, sz)
        Lg.setCanvas(ParticleCanvas)
        Lg.clear(0, 0, 0, 0)
        Lg.setColor(1, 1, 1, 1)
        -- diamond
        local cx, cy, h = sz/2, sz/2, sz/2 - 1
        Lg.polygon("fill", cx, cy-h, cx+h, cy, cx, cy+h, cx-h, cy)
        Lg.setCanvas()
    end
    return ParticleCanvas
end

-- cfg fields:
--   count          total particles emitted
--   speedMin/Max   launch speed in px/s
--   lifeMin/Max    particle lifetime seconds
--   sizeMin/Max    particle draw scale
--   damping        linear damping range {min,max}
--   shockwave      max radius of ring (0 = no ring)
--   duration       how long the entity lives (should cover particle life)
--   color          {r,g,b}
local PRESETS = {
    ant = {
        count     = 20,
        speedMin  = 40,  speedMax  = 120,
        lifeMin   = 0.3, lifeMax   = 0.9,
        sizeMin   = 0.4, sizeMax   = 0.7,
        damping   = {4, 8},
        shockwave = 18,
        duration  = 1.2,
        color     = {1, 0.7, 0.1},
    },
    spider = {
        count     = 700,
        speedMin  = 180, speedMax  = 550,
        lifeMin   = 0.8, lifeMax   = 2.5,
        sizeMin   = 0.6, sizeMax   = 2.0,
        damping   = {1.5, 4},
        shockwave = 110,
        duration  = 3.5,
        color     = {1, 0.85, 0.15},
    },
}

local DeathEffect = class("DeathEffect", Entity)

-- presetName: "ant" | "spider"  (or pass a custom cfg table)
function DeathEffect:initialize(x, y, presetName)
    Entity.initialize(self)

    local cfg = type(presetName) == "table" and presetName
                or (PRESETS[presetName] or PRESETS["ant"])

    self:add(Components.Position(x, y))

    local ps = Lg.newParticleSystem(getParticleCanvas(), cfg.count + 50)

    local r, g, b = cfg.color[1], cfg.color[2], cfg.color[3]
    ps:setColors(
        1,   1,   1,   1,   -- born: white-hot
        r,   g,   b,   0.9, -- mid: food amber
        r*0.7, g*0.5, 0, 0  -- out: fades dark
    )

    ps:setParticleLifetime(cfg.lifeMin, cfg.lifeMax)
    ps:setEmissionRate(0)
    ps:setSizeVariation(0.6)
    ps:setSizes(cfg.sizeMin, cfg.sizeMax, cfg.sizeMin * 0.3)
    ps:setLinearDamping(cfg.damping[1], cfg.damping[2])
    -- tiny random gravity jitter, not too much so they stay near source
    ps:setLinearAcceleration(-8, 0, 8, 30)
    ps:setSpeed(cfg.speedMin, cfg.speedMax)
    ps:setSpread(math.pi * 2)
    ps:setRotation(0, math.pi * 2)
    ps:setSpin(-4, 4)

    ps:emit(cfg.count)

    self:add(Components.ParticleEffect(ps, cfg.duration, cfg.color, cfg.shockwave))
    engine:addEntity(self)
end

return DeathEffect

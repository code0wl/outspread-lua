-- InsectSystem: lightweight ambient insects drawn in world-space.
-- Not part of the ECS engine. Call init(), update(dt) and draw()
-- from main.lua inside the GameState==1 block.

local InsectSystem = {}

-- ─── Type definitions ──────────────────────────────────────────────
local TYPES        = {
    { name = "beetle",  w = 5, h = 3, color = { 0.35, 0.18, 0.08 }, speed = 28, count = 10 },
    { name = "termite", w = 3, h = 2, color = { 0.82, 0.72, 0.35 }, speed = 58, count = 20 },
    { name = "fly",     w = 3, h = 2, color = { 0.25, 0.25, 0.25 }, speed = 100, count = 6 },
    { name = "grub",    w = 7, h = 4, color = { 0.88, 0.82, 0.62 }, speed = 12, count = 5 },
    { name = "earwig",  w = 6, h = 2, color = { 0.50, 0.25, 0.08 }, speed = 42, count = 8 },
}

local _insects     = {}
local MARGIN       = 120

local function rp()
    return math.random(MARGIN, GlobalWidth - MARGIN),
        math.random(MARGIN, GlobalHeight - MARGIN)
end

local function newInsect(def)
    local x, y   = rp()
    local tx, ty = rp()
    return {
        def     = def,
        x       = x,
        y       = y,
        tx      = tx,
        ty      = ty,
        heading = math.random() * math.pi * 2,
        wphase  = math.random() * math.pi * 2,
        life    = 40 + math.random() * 80,
    }
end

-- ─── Public API ────────────────────────────────────────────────────

function InsectSystem.init()
    _insects = {}
    for _, def in ipairs(TYPES) do
        for _ = 1, def.count do
            table.insert(_insects, newInsect(def))
        end
    end
end

function InsectSystem.update(dt)
    local now = love.timer.getTime()
    for i, ins in ipairs(_insects) do
        local def = ins.def
        ins.life  = ins.life - dt

        local dx  = ins.tx - ins.x
        local dy  = ins.ty - ins.y

        -- Retarget when close
        if dx * dx + dy * dy < 64 then
            ins.tx, ins.ty = rp()
            dx = ins.tx - ins.x
            dy = ins.ty - ins.y
        end

        -- Smooth steering with a slow wander sway
        local desired = math.atan2(dy, dx)
        local wander  = math.sin(now * 0.8 + ins.wphase) * 0.22
        local diff    = ((desired + wander - ins.heading + math.pi) % (math.pi * 2)) - math.pi
        local step    = math.min(math.abs(diff), 3.8 * dt)
        ins.heading   = ins.heading + (diff > 0 and step or -step)

        ins.x         = math.max(MARGIN, math.min(GlobalWidth - MARGIN,
            ins.x + math.cos(ins.heading) * def.speed * dt))
        ins.y         = math.max(MARGIN, math.min(GlobalHeight - MARGIN,
            ins.y + math.sin(ins.heading) * def.speed * dt))

        -- Respawn when life expires
        if ins.life <= 0 then
            _insects[i] = newInsect(def)
        end
    end
end

function InsectSystem.draw()
    for _, ins in ipairs(_insects) do
        local c = ins.def.color
        Lg.setColor(c[1], c[2], c[3], 0.70)
        Lg.push()
        Lg.translate(ins.x, ins.y)
        Lg.rotate(ins.heading)
        Lg.ellipse("fill", 0, 0, ins.def.w, ins.def.h)
        -- Small head dot
        Lg.setColor(c[1] * 0.6, c[2] * 0.6, c[3] * 0.6, 0.70)
        Lg.ellipse("fill", ins.def.w * 0.6, 0, ins.def.h * 0.7, ins.def.h * 0.7)
        Lg.pop()
    end
    Lg.setColor(1, 1, 1, 1)
end

return InsectSystem

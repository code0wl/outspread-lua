-- Create a draw System.
local AnimationDrawSystem = class("AnimationDrawSystem", System)

function AnimationDrawSystem:requires()
    return { "position", "scale", "dimension", "animation" }
end

function AnimationDrawSystem:draw()
    local drawList = {}

    for _, entity in pairs(self.targets) do
        if entity.isAlive ~= false then
            table.insert(drawList, entity)
        end
    end

    -- Sort largest objects first to render as a backplate to swarms
    table.sort(drawList, function(a, b)
        local dimA = a:get("dimension")
        local dimB = b:get("dimension")
        return (dimA.width * dimA.height) > (dimB.width * dimB.height)
    end)

    for _, entity in ipairs(drawList) do
        local position  = entity:get("position")
        local dimension = entity:get("dimension")
        local scale     = entity:get("scale")

        -- Use the steering heading when available so the sprite always faces
        -- the direction the ant is actually travelling.
        local angle     = entity.heading
            or util.getAngle(entity.target.y, position.y,
                entity.target.x, position.x)

        entity.animation:draw(entity.image, position.x, position.y,
            angle,
            scale.amount, scale.amount,
            util.getCenter(dimension.width),
            util.getCenter(dimension.height))

        -- Visible food particle carried on the ant's back
        if entity.hasFood and entity.heading then
            local hw      = dimension.width  * scale.amount * 0.5
            -- Offset: slightly in front of centre, along heading
            local ox      = math.cos(entity.heading) * hw * 0.55
            local oy      = math.sin(entity.heading) * hw * 0.55
            local fx, fy  = position.x + ox, position.y + oy
            -- Outer glow
            Lg.setColor(1.0, 0.70, 0.10, 0.35)
            Lg.ellipse("fill", fx, fy, 4.5, 4.5)
            -- Core pellet (warm amber, no red/black tint)
            Lg.setColor(1.0, 0.82, 0.22, 0.92)
            Lg.ellipse("fill", fx, fy, 2.6, 2.6)
            Lg.setColor(1, 1, 1, 1)
        end
    end
end

return AnimationDrawSystem

local ParticleEffectDrawSystem = class("ParticleEffectDrawSystem", System)

function ParticleEffectDrawSystem:requires()
    return { "particleEffect", "position" }
end

function ParticleEffectDrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local effect = entity:get("particleEffect")
        local pos    = entity:get("position")

        Lg.setBlendMode("add")

        -- shockwave ring: expands fast and fades
        if effect.shockwave and effect.shockwave > 0 then
            local ringDur  = effect.duration * 0.25   -- ring done at 25 % of total
            local progress = math.min(effect.timer / ringDur, 1)
            if progress < 1 then
                local radius = progress * effect.shockwave
                local alpha  = (1 - progress) * 0.9
                local r, g, b = effect.color[1], effect.color[2], effect.color[3]
                -- outer glow ring
                Lg.setColor(r, g, b, alpha * 0.4)
                Lg.setLineWidth(effect.shockwave * 0.08)
                Lg.circle("line", pos.x, pos.y, radius * 1.15)
                -- sharp inner ring
                Lg.setColor(1, 1, 1, alpha)
                Lg.setLineWidth(1.5)
                Lg.circle("line", pos.x, pos.y, radius)
                Lg.setLineWidth(1)
            end
        end

        Lg.setColor(1, 1, 1, 1)
        Lg.draw(effect.psystem, pos.x, pos.y)
        Lg.setBlendMode("alpha")
    end
end

return ParticleEffectDrawSystem

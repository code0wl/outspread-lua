local ParticleEffectSystem = class("ParticleEffectSystem", System)

function ParticleEffectSystem:requires()
    return {"particleEffect", "position"}
end

function ParticleEffectSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local effect = entity:get("particleEffect")
        
        effect.timer = effect.timer + dt
        effect.psystem:update(dt)

        if effect.timer >= effect.duration then
            engine:removeEntity(entity)
            if world:hasItem(entity) then world:remove(entity) end
        end
    end
end

return ParticleEffectSystem

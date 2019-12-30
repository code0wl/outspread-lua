-- move System
local AnimationSystem = class("AnimationSystem", System)

function AnimationSystem:requires() return {"animation"} end

function AnimationSystem:update(dt)
    for _, entity in pairs(self.targets) do
        if entity.isAlive then entity.animation:update(dt) end
    end
end

return AnimationSystem


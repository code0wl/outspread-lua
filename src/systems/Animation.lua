-- move System
local AnimationSystem = class("AnimationSystem", System)

function AnimationSystem:requires() return {"animation"} end

function AnimationSystem:update(dt)
    for _, entity in pairs(self.targets) do entity.animation:update(dt) end
end

return AnimationSystem


-- move System
local AnimationSystem = class("AnimationSystem", System)

function AnimationSystem:requires()
    return {"animation"}
end

function AnimationSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local dimension = entity:get("dimension")
        if util.distanceBetween(entity.target.x, entity.target.y, position.x, position.y) > 10 and entity.isAlive then
            entity.animation:update(dt)
        end
    end
end

return AnimationSystem

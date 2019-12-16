-- move System
local SpiderMoveSystem = class("SpiderMoveSystem", System)

function SpiderMoveSystem:requires()
    return {"position", "velocity", "spider", "energy"}
end

function SpiderMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local energy = entity:get("energy")
        local velocity = entity:get("velocity")

        if not entity.signal.aggressionSignalActive and TimePassedAntSpider > 6 then
            energy.amount = energy.amount - .5
            TimePassedAntSpider = 0
            self.target = util.travelRandomly()
        end

        position.x, position.y = util.setDirection(position.x, position.y,
                                                   velocity.speed,
                                                   entity.target, dt)

    end
end

return SpiderMoveSystem

-- move System
local SpiderMoveSystem = class("SpiderMoveSystem", System)

function SpiderMoveSystem:requires()
    return {"position", "velocity", "spider", "energy", "signal"}
end

function SpiderMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local energy = entity:get("energy")
        local velocity = entity:get("velocity")
        local signal = entity:get("signal")

        signal.aggressionSignalActive = false

        entity.TimePassedSpider = entity.TimePassedSpider + 1 * dt

        if not signal.aggressionSignalActive and entity.TimePassedSpider >
            math.random(3, 6) then
            energy.amount = energy.amount - .5
            entity.TimePassedSpider = 0
            entity.target = Components.Position(util.travelRandomly())
        end

        position.x, position.y = util.setDirection(position.x, position.y,
                                                   velocity.speed,
                                                   entity.target, dt)

    end
end

return SpiderMoveSystem

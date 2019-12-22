-- move System
local AntMoveSystem = class("AntMoveSystem", System)

function AntMoveSystem:requires()
    return {"position", "velocity", "ant", "signal"}
end

function AntMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get('position')
        local velocity = entity:get('velocity')
        local signal = entity:get('signal')

        entity.TimePassedAnt = entity.TimePassedAnt + 1 * dt

        if entity.hasFood then entity.target = entity.nest end

        -- Walk randomnly
        if not signal.aggressionSignalActive and entity.TimePassedAnt >
            math.random(2, 4) then
            entity.TimePassedAnt = 0
            entity.target = Components.Position(util.travelRandomly())
        end

        -- Follow scent
        if not self.hasFood and self.scentLocation then
            self.target = Components.Position(self.scentLocation.x,
                                              self.scentLocation.y)
        end

        -- deliver food to nest
        entity:returnFoodToNest(entity.nest)

        position.x, position.y = util.setDirection(position.x, position.y,
                                                   velocity.speed,
                                                   entity.target, dt)

        self.angle = util.getAngle(entity.target.y, position.y, entity.target.x,
                                   position.x) + 1.6 + math.pi
    end
end

return AntMoveSystem

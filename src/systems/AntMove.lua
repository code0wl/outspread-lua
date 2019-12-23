-- move System
local AntMoveSystem = class("AntMoveSystem", System)

function AntMoveSystem:requires() return {"ant"} end

function AntMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get('position')
        local velocity = entity:get('velocity')

        entity.TimePassedAnt = entity.TimePassedAnt + 1 * dt

        if entity.hasFood then entity.target = entity.nest end

        -- Walk randomnly
        if entity.TimePassedAnt > math.random(2, 4) then
            entity.TimePassedAnt = 0
            entity.target = Components.Position(util.travelRandomly())
        end

        -- if out of bounds 
        if util.isOutOfBounds(position.x, position.y) then
            entity.target = entity.nest
        end

        entity.angle = util.getAngle(entity.target.y, position.y,
                                     entity.target.x, position.x) * math.pi

        position.x, position.y = util.setDirection(position.x, position.y,
                                                   velocity.speed,
                                                   entity.target, dt)

    end
end

return AntMoveSystem

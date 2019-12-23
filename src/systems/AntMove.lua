-- move System
local AntMoveSystem = class("AntMoveSystem", System)

function AntMoveSystem:requires() return {"ant"} end

function AntMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local velocity = entity:get('velocity')

        entity.TimePassedAnt = entity.TimePassedAnt + 1 * dt

        if entity.hasFood then entity.target = entity.nest end

        -- Walk randomnly
        if entity.TimePassedAnt > math.random(2, 4) then
            entity.TimePassedAnt = 0
            entity.target = Components.Position(util.travelRandomly())
        end

        -- if out of bounds 
        if util.isOutOfBounds(entity.body:getX(), entity.body:getY()) then
            entity.target = entity.nest
        end

        entity.angle = util.getAngle(entity.target.y, entity.body:getY(),
                                     entity.target.x, entity.body:getX()) *
                           math.pi

        entity.body:setPosition(util.setDirection(entity.body:getX(),
                                                  entity.body:getY(),
                                                  velocity.speed, entity.target,
                                                  dt))

    end
end

return AntMoveSystem

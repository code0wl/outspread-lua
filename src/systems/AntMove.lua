-- move System
local AntMoveSystem = class("AntMoveSystem", System)

function AntMoveSystem:requires() return {"ant"} end

function AntMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get('position')
        local velocity = entity:get('velocity')

        local speed = velocity.speed * dt - math.pi
        entity.TimePassedAnt = entity.TimePassedAnt + 1 * dt

        if entity.hasFood then
            entity.target = entity.nest
        else
            entity.target = Components.Position(500, 500)
        end

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
                                     entity.target.x, position.x)

        local futureX = position.x + speed
        local futureY = position.y + speed

        local nextX, nextY, cols, len = world:move(entity, futureX, futureY)

        position.x, position.y = util.setDirection(nextX, nextY, velocity.speed,
                                                   entity.target, dt)

        -- Collision resolution
        -- Refactor later
        for i = 1, len do
            local other = cols[i].other
            if entity.type == other.type then return nil end
        end

    end
end

return AntMoveSystem

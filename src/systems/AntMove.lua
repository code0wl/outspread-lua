-- move System
local AntMoveSystem = class("AntMoveSystem", System)

function AntMoveSystem:requires() return {"ant"} end

local antFilter = function(item, other)
    if item.type ~= other.type then
        item:attack(other)
        other:attack(item)
        return 'bounce'
    elseif not item.dead and other.dead then
        item:carry(other)
    end
end

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
                                     entity.target.x, position.x)

        local futureX = position.x
        local futureY = position.y

        local nextX, nextY = world:move(entity, futureX, futureY, antFilter)

        position.x, position.y = util.setDirection(nextX, nextY, velocity.speed,
                                                   entity.target, dt)

    end
end

return AntMoveSystem

-- move System
local AntMoveSystem = class("AntMoveSystem", System)

function AntMoveSystem:requires() return {"ant"} end

local antFilter = function(item, other)
    local itemAlive = not item.dead
    local otherAlive = not other.dead
    local otherDead = other.dead

    --  Handle all actions if ant is alive
    if itemAlive and otherAlive then
        if item.type ~= other.type then
            item:attack(other)
            return 'bounce'
        end
    end

    --  handle dead vars
    if itemAlive and otherDead then
        item:carry(other)
        return nil
    end

end

function AntMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get('position')
        local velocity = entity:get('velocity')
        local nestPosition = entity.nest:get('position')

        entity.TimePassedAnt = entity.TimePassedAnt + 1 * dt

        -- Is carrying food
        if entity.hasFood then entity.target = nestPosition end

        -- Deliver food to nest
        if entity.food and
            util.distanceBetween(position.x, position.y, nestPosition.x,
                                 nestPosition.y) < 50 then
            entity.nest:receiveFood(entity.carryCapacity)
            entity.hasFood = false
        end

        -- Walk randomnly
        if not entity.food and entity.TimePassedAnt > math.random(2, 4) then
            entity.TimePassedAnt = 0
            entity.target = Components.Position(util.travelRandomly())
        end

        -- if out of bounds 
        if util.isOutOfBounds(position.x, position.y) then
            entity.target = nestPosition
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

-- move System
local AntMoveSystem = class("AntMoveSystem", System)

function AntMoveSystem:requires() return {"ant"} end

local antFilter = function(item, other)
    local itemAlive = not item.dead
    local otherAlive = not other.dead
    local otherDead = other.dead

    if itemAlive and otherAlive then
        --  Handle all actions if ant is alive
        if item.type ~= other.type then
            item:attack(other)
            other:attack(item)
            return 'bounce'
        end
    end

    if itemAlive and otherDead then
        item:carry(other)
        engine:removeEntity(other)
        world:remove(other)
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
        if entity.food then
            entity.food:get('position').x, entity.food:get('position').y = position.x, position.y
            entity.target = nestPosition

            -- Deliver food to nest
            if util.distanceBetween(position.x, position.y, nestPosition.x, nestPosition.y) < 10 then
                entity.nest:receiveFood(entity.food:get('food').amount)
                entity.food.amount = nil
                entity.food = nil
            end
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

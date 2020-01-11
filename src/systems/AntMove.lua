-- move System
local AntMoveSystem = class("AntMoveSystem", System)

function AntMoveSystem:requires() return {"ant"} end

local antFilter = function(ant, other)
    local antAlive = ant.isAlive
    local otherAlive = other.isAlive
    local otherDead = not other.isAlive

    if antAlive and otherAlive then
        if ant.type ~= other.type then
            ant:attack(other)
            ant.scentlocation = other
            return 'bounce'
        elseif ant.scentlocation and not other.scentlocation then
            other.scentlocation = ant.scentlocation
            return nil
        end
    end

    --  handle dead vars
    if not ant.hasFood and antAlive and otherDead then
        ant:carry(other)
        ant.scentlocation = other
        ant.hasFood = true
        return nil
    end

end

function AntMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do

        if entity.isAlive and not entity.player then
            local position = entity:get('position')
            local velocity = entity:get('velocity')
            local nestPosition = entity.nest:get('position')

            entity.TimePassedAnt = entity.TimePassedAnt + 1 * dt

            -- Is carrying food
            if entity.hasFood then entity.target = nestPosition end

            -- Deliver food to nest
            if entity.hasFood and
                util.distanceBetween(position.x, position.y, nestPosition.x,
                                     nestPosition.y) <
                entity.nest:get("dimension").width then
                entity.nest:receiveFood(entity.carryCapacity)
                entity.hasFood = false
            end

            if entity.scentlocation and not entity.hasFood then
                entity.target = entity.scentlocation:get("position")
            end

            -- Search for food
            if not entity.scentlocation and not entity.hasFood and
                entity.TimePassedAnt > math.random(2, 4) then
                entity.TimePassedAnt = 0
                entity.target = Components.Position(util.travelRandomly())
            end

            if not entity.scentlocation and not entity.hasFood and
                util.distanceBetween(position.x, position.y, entity.target.x,
                                     entity.target.y) < 3 then
                entity.target = Components.Position(util.travelRandomly())
            end

            -- Scent is gone after there is no more food
            if entity.scentlocation and entity.scentlocation:get("food").amount <
                1 and not entity.hasFood then
                entity.scentlocation = nil
            end

            -- if out of bounds 
            if util.isOutOfBounds(position.x, position.y) then
                entity.target = nestPosition
            end

            -- if out of bounds 

            local futureX = position.x
            local futureY = position.y

            local nextX, nextY = world:move(entity, futureX, futureY, antFilter)

            position.x, position.y = util.setDirection(nextX, nextY,
                                                       velocity.speed,
                                                       entity.target, dt)
        end

    end
end

return AntMoveSystem

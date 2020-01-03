-- move System
local SpiderMoveSystem = class("SpiderMoveSystem", System)

function SpiderMoveSystem:requires() return {"spider"} end

local spiderFiler = function(item, other)
    local itemAlive = item.isAlive
    local otherAlive = other.isAlive

    --  Handle all actions if ant is alive
    if itemAlive and otherAlive then
        item:attack(other)
        return 'bounce'
    end

    if itemAlive and not otherAlive then
        item:eat(other)
        return nil
    end

end

function SpiderMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        if entity.isAlive then
            local position = entity:get("position")
            local velocity = entity:get("velocity")

            entity.TimePassedSpider = entity.TimePassedSpider + 1 * dt

            -- Search for food
            if entity.TimePassedSpider > math.random(6, 10) then
                entity.TimePassedSpider = 0
                entity.target = Components.Position(util.travelRandomly())
            end

            local futureX = position.x
            local futureY = position.y

            local nextX, nextY = world:move(entity, futureX, futureY,
                                            spiderFiler)

            position.x, position.y = util.setDirection(nextX, nextY,
                                                       velocity.speed,
                                                       entity.target, dt)

        end
    end
end

return SpiderMoveSystem

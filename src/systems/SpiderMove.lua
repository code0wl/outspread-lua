-- move System
local SpiderMoveSystem = class("SpiderMoveSystem", System)

function SpiderMoveSystem:requires() return {"spider", "energy"} end

local spiderFilter =
    function(item, other) return item.attack(other) 'bounce' end

function SpiderMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        if entity.isAlive then
            local position = entity:get("position")
            local energy = entity:get("energy")
            local velocity = entity:get("velocity")

            entity.TimePassedSpider = entity.TimePassedSpider + 1 * dt

            print('target', entity.target.x)

            if entity.TimePassedSpider > math.random(3, 6) then
                energy.amount = energy.amount - .5
                entity.TimePassedSpider = 0
                entity.target = Components.Position(util.travelRandomly())
            end

            entity.angle = util.getAngle(entity.target.y, position.y,
                                         entity.target.x, position.x)

            local futureX = position.x
            local futureY = position.y

            local nextX, nextY = world:move(entity, futureX, futureY,
                                            spiderFilter)

            position.x, position.y = util.setDirection(nextX, nextY,
                                                       velocity.speed,
                                                       entity.target, dt)

        end
    end
end

return SpiderMoveSystem

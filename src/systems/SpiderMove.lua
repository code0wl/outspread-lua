-- move System
local SpiderMoveSystem = class("SpiderMoveSystem", System)

function SpiderMoveSystem:requires() return {"position"} end

function SpiderMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local velocity = entity:get("velocity")

        entity.x, entity.y = position

        entity.animation:update(dt)

        print('called')

        if not entity.signal.aggressionSignalActive and TimePassedAntSpider > 6 then
            entity.target = util.travelRandomly()
        end

        position.x, position.y = util.setDirection(position.x, position.y, dt,
                                                   velocity.speed, entity.target)

    end

end

return SpiderMoveSystem

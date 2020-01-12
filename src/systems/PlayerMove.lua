-- move System
local PlayerMoveSystem = class("PlayerMoveSystem", System)

function PlayerMoveSystem:requires()
    return {"player"}
end

function PlayerMoveSystem:update(dt)
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local velocity = entity:get("velocity")

        function love.mousepressed(x, y, button)
            if button == 1 then
                print("moving towards", x, y)
                entity.target = Components.Position(x, y)
            end
        end

        -- if out of bounds
        local futureX = position.x
        local futureY = position.y

        local nextX, nextY = world:move(entity, futureX, futureY)

        while not position.x == entity.target.x and not position.y == entity.target.y do
            position.x, position.y = util.setDirection(nextX, nextY, velocity.speed, entity.target, dt)
        end
    end
end

return PlayerMoveSystem

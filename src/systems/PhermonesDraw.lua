-- Create a draw System.
local PhermonesDrawSystem = class("PhermonesDrawSystem", System)

function PhermonesDrawSystem:requires()
    return {"phermones"}
end

function PhermonesDrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local position = entity:get("phermones")

        function love.mousepressed(x, y, button)
            if button == 1 then
                entity.target = Components.Position(Cam:toWorld(x, y))
            end
        end

        Lg.setColor(1, 0, 0)
        Lg.circle("fill", position.x, position.y, 4, 4)
        Lg.setColor(255, 255, 255)
    end
end

return PhermonesDrawSystem

-- Create a draw System.
local DrawSignalSystem = class("DrawSignalSystem", System)

function DrawSignalSystem:requires() return {"signal"} end

function DrawSignalSystem:draw()
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local signal = entity:get("signal")

        if signal.aggressionSignalAcive then
            love.graphics.setColor(1, 0, 0)
        end

        Lg.circle("line", position.x, position.y, signal.aggressionSignalSize,
                  100)

    end

end

return DrawSignalSystem

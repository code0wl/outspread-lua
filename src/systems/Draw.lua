-- Create a draw System.
local DrawSystem = class("DrawSystem", System)

function DrawSystem:requires() return {"position"} end

function DrawSystem:draw()
    for _, entity in pairs(self.targets) do
        Lg.rectangle("fill", entity:get("position").x, entity:get("position").y,
                     10, 10)
    end
end

return DrawSystem

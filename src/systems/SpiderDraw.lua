-- Create a draw System.
local SpiderDrawSystem = class("SpiderDrawSystem", System)

function SpiderDrawSystem:requires() return {"position"} end

function SpiderDrawSystem:draw()
    for _, entity in pairs(self.targets) do
        Lg.rectangle("fill", entity:get("position").x, entity:get("position").y,
                     10, 10)
    end

end

return SpiderDrawSystem

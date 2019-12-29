-- move System
local BuildSystem = class("BuildSystem", System)

function BuildSystem:requires() return {"nest"} end

function BuildSystem:update(dt)
    for _, entity in pairs(self.targets) do entity:update() end
end

return BuildSystem

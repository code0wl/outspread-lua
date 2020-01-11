local WorkerAnt = require("entities/WorkerAnt")
local SoldierAnt = require("entities/SoldierAnt")
local ScoutAnt = require("entities/ScoutAnt")

-- move System
local BuildSystem = class("BuildSystem", System)

function BuildSystem:requires() return {"nest"} end

function BuildSystem:update()
    for _, entity in pairs(self.targets) do

        for i = 0, entity.ants.soldiers do
            entity.ants.soldiers = entity.ants.soldiers - 1
            engine:addEntity(SoldierAnt:new({type = entity.type, nest = entity}))
        end

        for i = 0, entity.ants.scouts do
            entity.ants.scouts = entity.ants.scouts - 1
            engine:addEntity(ScoutAnt:new({type = entity.type, nest = entity}))
        end

        for i = 0, entity.ants.workers do
            entity.ants.workers = entity.ants.workers - 1
            engine:addEntity(WorkerAnt:new({type = entity.type, nest = entity}))
        end

       if not PlayerInstance then
            PlayerInstance = WorkerAnt:new({type = entity.type, nest = entity, player = true})
            engine:addEntity(PlayerInstance)
        end
         
    end
end

return BuildSystem

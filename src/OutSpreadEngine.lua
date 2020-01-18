local AnimationDrawSystem = require("systems.AnimationDraw")
local StaticDrawSystem = require("systems.StaticDraw")
local FoodDrawSystem = require("systems.FoodDraw")
local SpiderMoveSystem = require("systems.SpiderMove")
local AntMoveSystem = require("systems.AntMove")
local AnimationSystem = require("systems.Animation")
local StatsSystem = require("systems.Stats")
local HealthSystem = require("systems.Health")
local BuildSystem = require("systems.Build")
local PhermonesDrawSystem = require("systems.PhermonesDraw")

local SpiderTarantula = require("entities.SpiderTarantula")

local OutSpreadEngine = {}

function OutSpreadEngine.addSystems()
    -- Update systems
    engine:addSystem(SpiderMoveSystem(), "update")
    engine:addSystem(AntMoveSystem(), "update")
    engine:addSystem(AnimationSystem(), "update")
    engine:addSystem(HealthSystem(), "update")
    engine:addSystem(BuildSystem(), "update")

    -- Draw systems
    engine:addSystem(PhermonesDrawSystem(), "draw")
    engine:addSystem(AnimationDrawSystem(), "draw")
    engine:addSystem(StaticDrawSystem(), "draw")
    engine:addSystem(StatsSystem(), "draw")
    engine:addSystem(FoodDrawSystem(), "draw")
end

return OutSpreadEngine

local AnimationDrawSystem  = require("systems.AnimationDraw")
local StaticDrawSystem     = require("systems.StaticDraw")
local FoodDrawSystem       = require("systems.FoodDraw")
local BodyPartDrawSystem   = require("systems.BodyPartDraw")
local FoodPelletSystem     = require("systems.FoodPelletSystem")
local FoodPelletDraw       = require("systems.FoodPelletDraw")
local ParticleEffectSystem = require("systems.ParticleEffect")
local ParticleEffectDraw   = require("systems.ParticleEffectDraw")
local SpiderMoveSystem     = require("systems.SpiderMove")
local AntMoveSystem        = require("systems.AntMove")
local AnimationSystem      = require("systems.Animation")
local StatsSystem          = require("systems.Stats")
local HealthSystem         = require("systems.Health")
local BuildSystem          = require("systems.Build")
local PhermonesDrawSystem  = require("systems.PhermonesDraw")

local OutSpreadEngine      = {}

function OutSpreadEngine.addSystems()
    -- Update systems
    engine:addSystem(SpiderMoveSystem(), "update")
    engine:addSystem(AntMoveSystem(), "update")
    engine:addSystem(AnimationSystem(), "update")
    engine:addSystem(ParticleEffectSystem(), "update")
    engine:addSystem(FoodPelletSystem(), "update")
    engine:addSystem(HealthSystem(), "update")
    engine:addSystem(BuildSystem(), "update")

    -- Draw systems
    engine:addSystem(PhermonesDrawSystem(), "draw")
    engine:addSystem(AnimationDrawSystem(), "draw")
    engine:addSystem(ParticleEffectDraw(), "draw")
    engine:addSystem(StaticDrawSystem(), "draw")
    engine:addSystem(StatsSystem(), "draw")
    engine:addSystem(FoodDrawSystem(), "draw")
    engine:addSystem(FoodPelletDraw(), "draw")
    engine:addSystem(BodyPartDrawSystem(), "draw") -- spider corpse chunks
end

return OutSpreadEngine

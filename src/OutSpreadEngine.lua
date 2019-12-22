local SpiderDrawSystem = require("systems.SpiderDraw")
local FoodDrawSystem = require("systems.FoodDraw")
local SpiderMoveSystem = require("systems.SpiderMove")
local EnergySystem = require("systems.Energy")
local AnimationSystem = require("systems.Animation")
local StatsSystem = require("systems.Stats")
local AntDrawSystem = require("systems.AntDraw")
local HealthSystem = require("systems.Health")

local SpiderTarantula = require("entities.SpiderTarantula")

local OutSpreadEngine = {}

function OutSpreadEngine.addSystems()
    local spider = SpiderTarantula:new({x = 100, y = 100})
    local spider2 = SpiderTarantula:new({x = 200, y = 400})
    local spider3 = SpiderTarantula:new({x = 500, y = 400})

    -- Test for engine
    engine:addEntity(spider)
    engine:addEntity(spider2)
    engine:addEntity(spider3)

    -- Update systems
    engine:addSystem(SpiderMoveSystem(), "update")
    engine:addSystem(AnimationSystem(), 'update')
    engine:addSystem(EnergySystem(), "update")
    engine:addSystem(HealthSystem(), "update")

    -- Draw systems
    engine:addSystem(FoodDrawSystem(), "draw")
    engine:addSystem(SpiderDrawSystem(), "draw")
    engine:addSystem(AntDrawSystem(), "draw")
    engine:addSystem(StatsSystem(), "draw")
end

return OutSpreadEngine

local SpiderDrawSystem = require("systems.SpiderDraw")
local FoodDrawSystem = require("systems.FoodDraw")
local SpiderMoveSystem = require("systems.SpiderMove")
local EnergySystem = require("systems.Energy")
local AnimationSystem = require("systems.Animation")
local StatsSystem = require("systems.Stats")
local HealthSystem = require("systems.Health")

local SpiderTarantula = require("entities.SpiderTarantula")

local OutSpreadEngine = {}

function OutSpreadEngine.addSystems()
    local spider = SpiderTarantula:new({x = 100, y = 100})
    local spiderTwo = SpiderTarantula:new({x = 1000, y = 1000})

    -- Test for engine
    engine:addEntity(spider)
    engine:addEntity(spiderTwo)

    -- Update systems
    engine:addSystem(SpiderMoveSystem(), "update")
    engine:addSystem(AnimationSystem(), 'update')
    engine:addSystem(EnergySystem(), "update")
    engine:addSystem(HealthSystem(), "update")

    -- Draw systems
    engine:addSystem(FoodDrawSystem(), "draw")
    engine:addSystem(SpiderDrawSystem(), "draw")
    engine:addSystem(StatsSystem(), "draw")
end

return OutSpreadEngine

local DrawSystem = require("systems.Draw")
local FoodDrawSystem = require("systems.FoodDraw")
local SpiderMoveSystem = require("systems.SpiderMove")
local AntMoveSystem = require("systems.AntMove")
local EnergySystem = require("systems.Energy")
local AnimationSystem = require("systems.Animation")
local StatsSystem = require("systems.Stats")
local HealthSystem = require("systems.Health")

local SpiderTarantula = require("entities.SpiderTarantula")

local OutSpreadEngine = {}

function OutSpreadEngine.addSystems()
    local spider = SpiderTarantula:new({x = 100, y = 100})

    -- Test for engine
    engine:addEntity(spider)

    -- Update systems
    engine:addSystem(SpiderMoveSystem(), "update")
    engine:addSystem(AntMoveSystem(), "update")
    engine:addSystem(AnimationSystem(), 'update')
    engine:addSystem(EnergySystem(), "update")
    engine:addSystem(HealthSystem(), "update")

    -- Draw systems
    engine:addSystem(FoodDrawSystem(), "draw")
    engine:addSystem(DrawSystem(), "draw")
    engine:addSystem(StatsSystem(), "draw")

end

return OutSpreadEngine

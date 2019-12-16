local SpiderDrawSystem = require("systems.SpiderDraw")
local SpiderMoveSystem = require("systems.SpiderMove")
local EnergySystem = require("systems.Energy")
local AnimationSystem = require("systems.Animation")
local HealthSystem = require("systems.Health")

local SpiderTarantula = require("entities.SpiderTarantula")

local OutSpreadEngine = {}

function OutSpreadEngine.addSystems()
    -- Do not add engine in custom wildlife arr
    local spider = SpiderTarantula:new({x = 100, y = 100})
    local spiderTwo = SpiderTarantula:new({x = 1000, y = 1000})

    engine:addEntity(spider)
    engine:addEntity(spiderTwo)
    engine:addSystem(SpiderMoveSystem(), "update")
    engine:addSystem(AnimationSystem(), 'update')
    engine:addSystem(EnergySystem(), "update")
    engine:addSystem(HealthSystem(), "update")
    engine:addSystem(SpiderDrawSystem(), "draw")
end

return OutSpreadEngine

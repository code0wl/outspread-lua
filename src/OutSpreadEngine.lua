local SpiderDrawSystem = require("systems.SpiderDraw")
local SpiderMoveSystem = require("systems.SpiderMove")
local EnergySystem = require("systems.Energy")

local SpiderTarantula = require("entities.SpiderTarantula")

local OutSpreadEngine = {}

function OutSpreadEngine.addSystems()
    -- Do not add engine in custom wildlife arr
    local spider = SpiderTarantula:new({x = 100, y = 100})

    table.insert(WildLife, spider)

    engine:addEntity(spider)
    engine:addSystem(SpiderMoveSystem(), "update")
    engine:addSystem(EnergySystem(), "update")
    engine:addSystem(SpiderDrawSystem(), "draw")
end

return OutSpreadEngine

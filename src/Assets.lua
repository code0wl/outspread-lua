local Colony = require("entities.Colony")
local SpiderDrawSystem = require("systems.SpiderDraw")
local SpiderMoveSystem = require("systems.SpiderMove")
local EnergySystem = require("systems.Energy")

local SpiderTarantula = require("entities.SpiderTarantula")

local level1 = sti("levels/level-1.lua")

BlackWalk = Lg.newImage("images/ants/spritesheets/ant1/_ant_walk-small.png")
RedWalk = Lg.newImage("images/ants/spritesheets/ant2/_ant_walk-small.png")
BlackWalkAnimationGrid = anim8.newGrid(16, 27, BlackWalk:getWidth(),
                                       BlackWalk:getHeight() + 1)
BlackWalkAnimation = anim8.newAnimation(BlackWalkAnimationGrid('1-5', 1, '1-5',
                                                               2, '1-5', 3),
                                        0.04)

RedWalkAnimationGrid = anim8.newGrid(16, 27, RedWalk:getWidth(),
                                     RedWalk:getHeight() + 1)
RedWalkAnimation = anim8.newAnimation(RedWalkAnimationGrid('1-5', 1, '1-5', 2,
                                                           '1-5', 3), 0.04)

DeadAntBlack = Lg.newImage("images/ants/spritesheets/ant1/_ant_dead-small.png")
DeadAntRed = Lg.newImage("images/ants/spritesheets/ant2/_ant_dead-small.png")

DeadTarantulaSpider = Lg.newImage(
                          "images/spiders/spider1/spritesheets/sheet_spider_die-small.png")

local function addSystems()
    -- Do not add engine in custom wildlife arr
    local spider = SpiderTarantula:new({x = 100, y = 100})

    table.insert(WildLife, spider)

    engine:addEntity(spider)
    engine:addSystem(SpiderMoveSystem(), 'update')
    engine:addSystem(EnergySystem(), 'update')
    engine:addSystem(SpiderDrawSystem(), "draw")
end

local asset = {}

function asset.generateWorldAssets()

    for _, obj in pairs(level1.layers["player_nest"].objects) do
        table.insert(Colonies, Colony:new(
                         {
                type = 1,
                x = obj.x,
                y = obj.y,
                population = 1000,
                width = obj.width,
                height = obj.height
            }))
    end

    for _, obj in pairs(level1.layers["enemy_nest"].objects) do
        table.insert(Colonies, Colony:new(
                         {
                type = 2,
                x = obj.x,
                y = obj.y,
                population = 1000,
                width = obj.width,
                height = obj.height
            }))
    end

    addSystems()
end

return asset


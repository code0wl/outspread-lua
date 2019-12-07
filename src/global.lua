-- shortcut to love graphics
Lp = love.physics
Lg = love.graphics
lw = love.window
lm = love.mouse

-- helper libs
sti = require("libs/sti")
anim8 = require('libs/anim8')
inspect = require("libs/inspect/inspect")

-- create instance for camera
globalWidth = 5000
globalHeight = 5000
local gamera = require('libs/gamera')
cam = gamera.new(0, 0, globalWidth, globalHeight)
cam:setWindow(0, 0, Lg.getWidth(), Lg.getHeight())

-- create world
world = love.physics.newWorld(0, 0, true)
TimePassedAnt = 0
TimePassedAntSpider = 0

-- own util
util = require("utils")

-- terain map
terrainSprites = {terrain = Lg.newImage("images/terrain/terrain.png")}

-- food map
foodSprites = {food = Lg.newImage("images/food/food.png")}

-- game states
Colonies = {}
FoodCollection = {}

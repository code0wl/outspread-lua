-- shortcut to love graphics
lp = love.physics
lg = love.graphics
lw = love.window
lm = love.mouse

-- helper libs
sti = require("libs/sti")
anim8 = require('libs/anim8')
inspect = require("libs/inspect/inspect")

-- create instance for camera
globalWidth = 5000
globalHeight = 5000
local gamera = require('libs/gamera/gamera')
cam = gamera.new(0, 0, globalWidth, globalHeight)
cam:setWindow(0, 0, lg.getWidth(), lg.getHeight())

-- create world
world = love.physics.newWorld(0, 0, true)
timePassed = 0
timePassedSpider = 0

-- own util
util = require("utils")

-- terain map
terrainSprites = {terrain = lg.newImage("images/terrain/terrain.png")}

-- food map
foodSprites = {food = lg.newImage("images/food/food.png")}

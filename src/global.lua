-- shortcut to love graphics
lp = love.physics
lg = love.graphics

-- set level size
love.window.setMode(1280, 720)

-- helper libs
sti = require("libs/sti")
anim8 = require('libs/anim8')

-- create instance for camera
local camera = require('libs/hump/camera')
cam = camera()

-- create world
world = love.physics.newWorld(0, 0, true)

-- own util
util = require("utils")

-- terain map
terrainSprites = {terrain = lg.newImage("images/terrain/terrain.png")}

-- food map
foodSprites = {food = lg.newImage("images/food/food.png")}

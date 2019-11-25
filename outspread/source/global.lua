-- shortcut to love graphics
lp = love.physics
lg = love.graphics

-- set level size
love.window.setMode(1000, 1000)

-- helper libs
sti = require("libs/sti")
anim8 = require('libs/anim8')
class = require('libs/30logs/30logs')
tiny = require("libs/tiny/tiny")

-- create instance for camera
local camera = require('libs/hump/camera')
cam = camera()

-- create world instance
myWorld = lp.newWorld(0, 0, false)

-- own util
util = require("utils")

-- terain map
terrainSprites = {
    terrain = lg.newImage("images/terrain/terrain.png")
}

-- food map
foodSprites = {
    food = lg.newImage("images/food/food.png"),
}

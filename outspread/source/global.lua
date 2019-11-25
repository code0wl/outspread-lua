-- shortcut to love graphics
lp = love.physics
lg = love.graphics

-- set level size
love.window.setMode(2400, 2400)

-- helper libs
sti = require("libs/sti")
anim8 = require('libs/anim8')
class = require('libs.30logs/30logs')
tiny = require("libs.tiny/tiny")
myWorld = lp.newWorld(0, 0, false)

-- create instance for camera
local camera = require('libs/hump/camera')
cam = camera()
cam.smooth.linear(100)

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

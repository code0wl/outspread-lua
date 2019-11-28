lp = love.physics

sti = require("libs/sti")
graphics = require("graphics")
anim8 = require('libs/anim8')
local camera = require('libs/hump/camera')
cam = camera()
love.window.setMode(1280, 720)
myWorld = lp.newWorld(0, 0, false)
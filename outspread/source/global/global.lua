-- shortcut to love graphics
lp = love.physics
lg = love.graphics

-- set level size
love.window.setMode(2000, 2000)

-- helper libs
sti = require("libs/sti")
Class = require "libs/hump.class"
anim8 = require('libs/anim8')

-- create instance for camera
local camera = require('libs/hump/camera')
cam = camera()

-- create physics world
antWorld = lp.newWorld(100, 0, false)

-- own util
util = require("util.utils")

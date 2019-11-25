-- shortcut to love graphics
lp = love.physics
lg = love.graphics

-- set level size
love.window.setMode(2000, 2000)

-- helper libs
sti = require("libs/sti")
anim8 = require('libs/anim8')
tiny = require('libs/tiny/system')
talkingSystem = tiny.processingSystem()

talkingSystem.filter = tiny.requireAll("name", "mass", "phrase")

function talkingSystem:process(e, dt)
    e.mass = e.mass + dt * 3
    print(("%s who weighs %d pounds, says %q."):format(e.name, e.mass, e.phrase))
end

local joe = {
    name = "Joe",
    phrase = "I'm a plumber.",
    mass = 150,
    hairColor = "brown"
}

world = tiny.world(talkingSystem, joe)

-- create instance for camera
local camera = require('libs/hump/camera')
cam = camera()

-- own util
util = require("utils")

-- terain map
terrainSprites = {
    terrain = lg.newImage("images/terrain/terrain.png")
}

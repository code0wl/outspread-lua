-- shortcut to love graphics
Lp = love.physics
Lg = love.graphics
Lm = love.mouse
Lk = love.keyboard

-- helper libs
sti = require("libs/sti")
anim8 = require('libs/anim8')
inspect = require("libs/inspect/inspect")
class = require("libs.middleclass")
lovetoys = require("libs.lovetoys")
lovetoys.initialize({globals = true})

-- create instance for Camera
GlobalWidth = 3000
GlobalHeight = 3000
local gamera = require('libs.gamera')
Cam = gamera.new(0, 0, GlobalWidth, GlobalHeight)
Cam:setWindow(0, 0, Lg.getWidth(), Lg.getHeight())

-- own util
util = require("utils")

-- terain map
TerrainSprites = {terrain = Lg.newImage("images/terrain/terrain.png")}

-- food map
FoodSprites = {food = Lg.newImage("images/food/food.png")}

-- Player class
Player = require("entities/Player")

-- ECS engine 
engine = Engine()

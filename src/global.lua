-- shortcut to love graphics
Lp = love.physics
Lg = love.graphics
Lm = love.mouse
Lk = love.keyboard

-- helper libs
suit = require("libs/_suit")
sti = require("libs/sti")
anim8 = require('libs/anim8')
inspect = require("libs/inspect/inspect")
class = require("libs.middleclass")
local lovetoys = require("libs._lovetoys")
lovetoys.initialize({globals = true})

-- Game state management
-- 1 detailed game
-- 2 world view
-- 3 main menu
-- 4 options menu
-- 5 options settings
GameState = 1

-- collision
local bump = require("libs.bump")
world = bump.newWorld(16)

-- create instance for Camera
GlobalWidth = 4000
GlobalHeight = 2500
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
playerColony = nil

-- ECS engine 
engine = Engine()

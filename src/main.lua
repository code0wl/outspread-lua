require("global")
require("Mouse")
require("PrepareImages")
require("HUD")

local Phermones       = require("entities.Phermones")
local Levels          = require("Levels")
local WorldMap        = require("Worldmap")
local OutSpreadEngine = require("OutSpreadEngine")
local Control         = require("Control")
local GameData        = require("GameData")
local SaveSystem      = require("SaveSystem")
local player          = Phermones:new()

function love.load()
    OutSpreadEngine.addSystems()
    GameData.init(Levels)
end

function love.keypressed(key)
    if key == "f5" then SaveSystem.save(GameData) end
    if key == "f9" then SaveSystem.load(GameData) end
end

function love.update(dt)
    if BackgroundImage then
        BackgroundImage:setWrap("repeat", "repeat")
        QuadBQ = Lg.newQuad(0, 0, GlobalWidth, GlobalHeight, BackgroundImage:getWidth(), BackgroundImage:getHeight())
    end

    if GameState == 1 then
        Cam:setWorld(0, 0, GlobalWidth, GlobalHeight)
        engine:update(dt)
    end

    if GameState == 2 then
        Cam:setWorld(0, 0, Lg.getWidth(), Lg.getHeight())
    end

    GameData.update(dt, Levels)
    Control.update(dt)
end

function love.draw()
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

    if GameState == 1 then
        Cam:draw(
            function(l, t, w, h)
                -- make dynamic background
                Lg.draw(BackgroundImage, QuadBQ, 0, 0)
                engine:draw()
                UpdateCameraLocation(mouseX, mouseY, currentX, currentY)
            end
        )
    end

    if GameState == 2 then
        Cam:draw(
            function(l, t, w, h)
                if GameState == 2 then
                    WorldMap:draw()
                    UpdateCameraLocation(mouseX, mouseY, currentX, currentY)
                end
            end
        )
    end

    Hud()

    suit.draw()
end

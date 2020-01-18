require("global")
require("Mouse")
require("PrepareImages")
require("HUD")

local Phermones = require("entities.Phermones")
local WorldMap = require("Worldmap")
local OutSpreadEngine = require("OutSpreadEngine")
local Control = require("Control")
local player = Phermones:new()

function love.load()
    OutSpreadEngine.addSystems()
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

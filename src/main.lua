require("global")
require("Mouse")
require("HUD")
require("PrepareImages")

local WorldMap = require("Worldmap")
local asset = require("Assets")
local OutSpreadEngine = require("OutSpreadEngine")
local Control = require("Control")

-- needs to be variable

function love.load()
    asset.generateWorldAssets()
    OutSpreadEngine.addSystems()
end

function love.update(dt)

    if BackgroundImage then 
        BackgroundImage:setWrap("repeat", "repeat")

            QuadBQ = Lg.newQuad(0, 0, GlobalWidth, GlobalHeight,
                                BackgroundImage:getWidth(), BackgroundImage:getHeight())
        
    end
    
    if GameState == 1 then
        Cam:setWorld(0, 0, GlobalWidth, GlobalHeight)
        engine:update(dt)
        Player:update(dt)
    end

    if GameState == 2 then
        Cam:setScale(1)
        Cam:setWorld(0, 0, 500, 500)
    end

    Control.update(dt)
end

function love.draw()
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

    if GameState == 1 then
        Cam:draw(function(l, t, w, h)
            -- make dynamic background
            Lg.draw(BackgroundImage, QuadBQ, 0, 0)
            engine:draw()
            UpdateCameraLocation(mouseX, mouseY, currentX, currentY)
        end)
    end

    if GameState == 2 then Cam:draw(function(l, t, w, h) WorldMap:draw() end) end

    suit.draw()

    Hud()

end


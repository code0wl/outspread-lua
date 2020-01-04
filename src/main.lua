require("Global")
require("Mouse")
require("HUD")
require("PrepareImages")

local WorldMap = require("WorldMap")
local asset = require("Assets")
local OutSpreadEngine = require("OutSpreadEngine")
local Control = require("Control")

-- needs to be variable
local bg_image = Lg.newImage("/images/background/background.png")

bg_image:setWrap("repeat", "repeat")

-- note how the Quad's width and height are larger than the image width and height.
QuadBQ = Lg.newQuad(0, 0, GlobalWidth, GlobalHeight, bg_image:getWidth(),
                    bg_image:getHeight())

function love.load()
    asset.generateWorldAssets()
    OutSpreadEngine.addSystems()
end

function love.update(dt)

    if GameState == 1 then
        Cam:setWorld(0, 0, GlobalWidth, GlobalHeight)
        engine:update(dt)
        Player:update(dt)
    end

    if GameState == 2 then Cam:setWorld(0, 0, 500, 500) end

    Control.update(dt)
end

function love.draw()
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

    if GameState == 1 then
        Cam:draw(function(l, t, w, h)
            -- make dynamic background
            Lg.draw(bg_image, QuadBQ, 0, 0)
            engine:draw()
            UpdateCameraLocation(mouseX, mouseY, currentX, currentY)
        end)
    end

    if GameState == 2 then Cam:draw(function(l, t, w, h) WorldMap:draw() end) end

    suit.draw()

    Hud()

end


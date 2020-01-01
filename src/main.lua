require("Global")
require("Mouse")
require("HUD")
require("PrepareImages")

local asset = require("Assets")
local OutSpreadEngine = require("OutSpreadEngine")
local Control = require("Control")

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
        engine:update(dt)
        Player:update()
    end

    if GameState == 2 then print('some content to check performance') end

    Control.update(dt)
end

function love.draw()
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

    if GameState == 1 then

        -- Camera for detailed view
        Cam:draw(function(l, t, w, h)

            -- make dynamic background
            Lg.draw(bg_image, QuadBQ, 0, 0)

            engine:draw()

            UpdateCameraLocation(mouseX, mouseY, currentX, currentY)

        end)

    end

    if GameState == 2 then print('lets put a backgorund here') end

    suit.draw()

    Hud()

end


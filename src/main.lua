require("Global")
require("Mouse")
require("Debug")
require("PrepareImages")

local asset = require("Assets")
local OutSpreadEngine = require("OutSpreadEngine")
local Control = require("Control")

local gameState = 1

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
    engine:update(dt)
    Player:update()
    Control.update(dt)
end

function love.draw()
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

    if gameState == 1 then
        -- Camera
        Cam:draw(function(l, t, w, h)

            Lg.draw(bg_image, QuadBQ, 0, 0)

            -- Draw player phermones
            for _, phermone in ipairs(Player.phermones) do
                Lg.setColor(255, 153, 153)
                Lg.circle('fill', phermone.x, phermone.y, 5)
            end

            engine:draw()

            UpdateCameraLocation(mouseX, mouseY, currentX, currentY)

        end)

    end

    if gameState == 2 then
        -- Camera
        Cam:draw(function(l, t, w, h) print("some other shit") end)

    end

    if gameState == 3 then
        -- Camera
        Cam:draw(function(l, t, w, h) print("some other shit") end)
    end

    suit.draw()

    PrintDetailsToScreen()

end


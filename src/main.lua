require("Global")
require("Mouse")
require("Debug")
require("PrepareImages")
local input = {text = ""}

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
    engine:update(dt)
    Player:update()
    Control.update(dt)

    -- put the layout origin at position (100,100)
    -- the layout will grow down and to the right from this point
    suit.layout:reset(100, 100)

    -- put an input widget at the layout origin, with a cell size of 200 by 30 pixels
    suit.Input(input, suit.layout:row(200, 30))

    -- put a label that displays the text below the first cell
    -- the cell size is the same as the last one (200x30 px)
    -- the label text will be aligned to the left
    suit.Label("Hello, " .. input.text, {align = "left"}, suit.layout:row())

    -- put an empty cell that has the same size as the last cell (200x30 px)
    suit.layout:row()

    -- put a button of size 200x30 px in the cell below
    -- if the button is pressed, quit the game
    if suit.Button("Close", suit.layout:row()).hit then love.event.quit() end
end

function love.draw()
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

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

    suit.draw()

    PrintDetailsToScreen()

end


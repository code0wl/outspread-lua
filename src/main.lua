require("Global")
require("Mouse")
require("Debug")
require("PrepareImages")

local asset = require("Assets")
local OutSpreadEngine = require("OutSpreadEngine")
local Ants = engine:getEntitiesWithComponent("ant")
local Colonies = engine:getEntitiesWithComponent("colony")
local Control = require("Control")

local bg_image = Lg.newImage("/images/background/background.png")

bg_image:setWrap("repeat", "repeat")

-- note how the Quad's width and height are larger than the image width and height.
QuadBQ = Lg.newQuad(0, 0, GlobalWidth, GlobalHeight, bg_image:getWidth(),
                    bg_image:getHeight())

function love.load()
    asset.generateWorldAssets()
    OutSpreadEngine.addSystems()

    print(Colonies)

end

function love.update(dt)
    engine:update(dt)

    Player:update()
    Control.update(dt)

    for colonyIndex, colony in ipairs(Colonies) do

        print(colonyIndex)
        -- for _, ant in ipairs(Ants) do
        --     print(ant)

        --     ant:update(engine:getEntitiesWithComponent("food"), dt)

        -- end
        -- colony.nest:update(dt)
    end

end

function love.draw()
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

    -- Camera
    Cam:draw(function(l, t, w, h)

        Lg.draw(bg_image, QuadBQ, 0, 0)

        -- draw nests
        for _, colony in ipairs(Colonies) do colony.nest:draw() end

        -- Draw player phermones
        for _, phermone in ipairs(Player.phermones) do
            Lg.setColor(255, 153, 153)
            Lg.circle('fill', phermone.x, phermone.y, 5)
        end

        engine:draw()

        UpdateCameraLocation(mouseX, mouseY, currentX, currentY)

    end)

    PrintDetailsToScreen(Colonies)

end


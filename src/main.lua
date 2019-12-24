require("Global")
require("Mouse")
require("Debug")
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
    world:setCallbacks(beginContact)
end

function love.update(dt)
    world:update(dt)
    engine:update(dt)
    Player:update(dt)
    Control.update(dt)
end

function love.draw()
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

    -- Camera
    Cam:draw(function(l, t, w, h)
        Lg.draw(bg_image, QuadBQ, 0, 0)
        engine:draw()
        UpdateCameraLocation(mouseX, mouseY, currentX, currentY)
    end)

    PrintDetailsToScreen(engine:getEntitiesWithComponent('nest'))

end

-- Move to director class
function beginContact(a, b)
    local actorA = a:getUserData()
    local actorB = b:getUserData()

    -- if actors exist and both can do damage
    if actorA and actorB then

        if actorA.damage and actorB.damage and actorA.type ~= actorB.type then
            print('attacking')
            actorA:attack(actorB)
            actorB:attack(actorA)
        end

        if actorA.dead or actorB.dead then actorB:carry(actorA) end

    end

end

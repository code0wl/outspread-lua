require("global")

local Colony = require("entities/Colony")
Colony(1, 100, 100, 100)

local maxZoom = 4
local maxOut = .5

function love.load()
    background = love.graphics.newImage("images/background/background.png")
    background:setWrap("repeat", "repeat")
    bg_quad = lg.newQuad(0, 0, lg.getWidth(), lg.getHeight(), background:getWidth(), background:getHeight())
    cam:zoom(1)
end

function love.update(dt)
    for _, colony in ipairs(Colony) do
        for _, ant in ipairs(colony.nest.ants) do
            ant.animation:update(dt)
        end
    end

    if love.mouse.isDown(2) then
        cam:lookAt(love.mouse.getX(), love.mouse.getY())
    end

    myWorld:update(dt)
end

function love.draw()
    cam:attach()
    lg.draw(background, bg_quad, 0, 0)

    -- draw ants
    for _, colony in ipairs(Colony) do
        colony.nest.draw()
        for _, ant in ipairs(colony.nest.ants) do
            ant.animation:draw(ant.currentState,
                ant.body:getX(),
                ant.body:getY(),
                ant.rotation,
                nil, nil,
                util.getCenter(ant.width),
                util.getCenter(ant.height))
        end
    end

    cam:detach()
end

function love.wheelmoved(x, y)
    if y > 0 and cam.scale < maxZoom then
        cam:zoom(1.05)
    elseif y < 0 and cam.scale > maxOut then
        cam:zoom(.95)
        util.logTable(cam)
    end
end


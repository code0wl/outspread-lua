require("global")
local Colony = require("entities/Colony")
local Food = require("entities/Food")
local Control = require("entities/Control")

Colony(1, 100, 100, 100)

local food = Food(1, 500, 500, 100)

local maxZoom = 4
local maxOut = .5
local control = Control(300)

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

    control:update(dt)
end

function love.draw()
    cam:attach()
    lg.draw(background, bg_quad, 0, 0)

    -- Later to come with tilemaps
    food.draw()

    -- draw ants
    for _, colony in ipairs(Colony) do
        colony.nest.draw()
        for _, ant in ipairs(colony.nest.ants) do
            ant.animation:draw(ant.currentState,
                ant.y,
                ant.x,
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
    end
end


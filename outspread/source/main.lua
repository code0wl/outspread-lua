require("global")

local Colony = require("entities/Colony")
local Food = require("entities/Food")
local Control = require("entities/Control")

Colony({
    type = 1,
    x = 100,
    y = 100,
    population = 100
})

local food = Food({
    type = 1,
    x = 500,
    y = 500,
    amount = 100
})

local maxZoom = 4
local maxOut = .5
local control = Control({ panspeed = 300 })

function love.load()
    background = love.graphics.newImage("images/background/background.png")
    background:setWrap("repeat", "repeat")
    bg_quad = lg.newQuad(0, 0, lg.getWidth(), lg.getHeight(), background:getWidth(), background:getHeight())
    cam:zoom(1)
end

function love.update(dt)
    myWorld:update(dt)

    for _, colony in ipairs(Colony) do
        for _, ant in ipairs(colony.nest.ants) do
            ant:update(dt)
        end
    end

    if love.mouse.isDown(1) then
        moveSwarm()
    end

    control:update(dt)
end

function love.draw()
    cam:attach()
    lg.draw(background, bg_quad, 0, 0)

    -- Later to come with tilemaps
    food:draw()

    -- draw ants
    for _, colony in ipairs(Colony) do
        colony.nest:draw()
        for _, ant in ipairs(colony.nest.ants) do
            ant:draw()
        end
    end

    cam:detach()
end

function moveSwarm()
    for _, colony in ipairs(Colony) do
        if colony.type == 1 then
            for _, ant in ipairs(colony.nest.ants) do
                local x, y = love.mouse.getPosition()
                ant.body:setX(x)
                ant.body:setY(y)
            end
        end
    end
end

-- love specific
function love.wheelmoved(x, y)
    if y > 0 and cam.scale < maxZoom then
        cam:zoom(1.05)
    elseif y < 0 and cam.scale > maxOut then
        cam:zoom(.95)
    end
end


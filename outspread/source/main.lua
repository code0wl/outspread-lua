require("global")

local Colony = require("entities/Colony")
Colony(1, 100, 100, 100)

function love.load()
    background = love.graphics.newImage("images/background/background.png")
    background:setWrap("repeat", "repeat")
    bg_quad = lg.newQuad(0, 0, lg.getWidth(), lg.getHeight(), background:getWidth(), background:getHeight())
end

function love.update(dt)
    for _, colony in ipairs(Colony) do
        for _, ant in ipairs(colony.nest.ants) do
            ant.animation:update(dt)
        end
    end

    myWorld:update(dt)
end

function love.draw()
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
end


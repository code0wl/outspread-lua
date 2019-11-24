require("colony/colony")

require("ant/ant")
require("global/global")

local someAnt2 = Ant:create(2, 500, 500, 3)
local someAnt = Ant:create(1, 300, 500, 1)

function love.load()
    background = love.graphics.newImage("images/background/background.png")
    background:setWrap("repeat", "repeat")
    bg_quad = lg.newQuad(0, 0, lg.getWidth(), lg.getHeight(), background:getWidth(), background:getHeight())
end

function love.update(dt)
    for i, a in ipairs(Colony) do
        for _, ant in ipairs(Colony[i]) do
            ant.animation:update(dt)
        end
    end
end

function love.draw()
    lg.draw(background, bg_quad, 0, 0)

    -- draw ants
    for i, a in ipairs(Colony) do
        for _, ant in ipairs(Colony[i]) do
            ant.animation:draw(ant.currentState,
                ant.x,
                ant.y,
                ant.rotation,
                nil, nil,
                util.getCenter(ant.width),
                util.getCenter(ant.height))
        end
    end
end


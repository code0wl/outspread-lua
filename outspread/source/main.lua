require("ant/ant")
require("global/global")

local someAnt2 = Ant:create(2, 500, 500)
local someAnt = Ant:create(1, 300, 500)

function love.load()
    background = love.graphics.newImage("images/background/background.png")
    antWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function love.update(dt)
    antWorld:update(dt)
    for i, a in ipairs(blackAnts) do
        a.animation:update(dt)
    end

    for i, a in ipairs(redAnts) do
        a.animation:update(dt)
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)

    for i, a in ipairs(redAnts) do
        a.animation:draw(a.currentState, a.x, a.y)
    end

    for i, a in ipairs(blackAnts) do
        a.animation:draw(a.currentState, a.x, a.y)
    end
end


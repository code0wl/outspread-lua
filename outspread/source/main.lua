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
    for i, a in ipairs(ants) do
        a.animation:update(dt)
    end
end

function love.draw()
    lg.draw(background, bg_quad, 0, 0)

    for i, a in ipairs(ants) do
        a.animation:draw(a.currentState, a.x, a.y)
    end
end


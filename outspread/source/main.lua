
require("ant/ant")
require("global/global")

function love.load()
    someAnt = Ant:create(1)
end

function love.update(dt)
    someAnt:update(dt)
end

function love.draw()
    someAnt:draw()
end


require("ant/ant")
require("global/global")

function love.load()
    someAnt = Ant:create(1)
    someAnt = Ant:create(2)
end

function love.update(dt)
    someAnt:update(dt)
end

function love.draw()
    someAnt:draw()
end


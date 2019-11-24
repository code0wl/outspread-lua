local util = require("util.utils")
local lg = love.graphics

function love.load()
    animation = util.newAnimation(lg.newImage("images/ants/spritesheets/ant1/_ant_walk-small.png"), 16, 27, .3)
end

function love.update(dt)
    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end
end

function love.draw()
    local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
    lg.draw(animation.spriteSheet, animation.quads[spriteNum], 0, 0, 0, 4)
end


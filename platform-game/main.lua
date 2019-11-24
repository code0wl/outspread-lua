local util = require("util")
local lg = love.graphics
local graphics = require("graphics")
local player = require("player")

function love.load()

end

function love.update(dt)

end

function love.draw()
    lg.draw(graphics.stand, player.x, player.y)
end


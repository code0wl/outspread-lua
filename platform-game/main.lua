require("world")
local util = require("util")
local lg = love.graphics
local graphics = require("graphics")
require("player")

function love.load()
    platforms = {}
    spawnPlatform(50, 400, 300, 30)
end

function love.update(dt)
    myWorld:update(dt)
end

function love.draw()
    lg.draw(graphics.stand, player.body:getX(), player.body:getY())

    for i, p in ipairs(platforms) do
        lg.rectangle("fill", p.body:getX(), p.body:getY(), p.width, p.height)
    end
end

function spawnPlatform(x, y, width, height)
    local platform = {}
    platform.body = lp.newBody(myWorld, x, y, 'static')
    platform.shape = lp.newRectangleShape(width, height)
    platform.fixture = lp.newFixture(platform.body, platform.shape)
    platform.width = width
    platform.height = height

    table.insert(platforms, platform)
end
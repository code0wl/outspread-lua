require("world")
util = require("util")
lg = love.graphics
require("coin")
require("player")

function love.load()
    platforms = {}



    gameMap = sti("maps/platform.lua")

    for i, obj in ipairs(gameMap.layers["platforms"].objects) do
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in ipairs(gameMap.layers["coins"].objects) do
        spawnCoin(obj.x, obj.y, obj.width, obj.height)
    end
end

function love.update(dt)
    myWorld:update(dt)
    player.update(dt)
    coinUpdate(dt)
    gameMap:update(dt)

    cam:lookAt(player.body:getX(), util.getCenter(lg.getHeight()))
end

function love.draw()
    cam:attach()
    gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
    lg.draw(player.sprite, player.body:getX(), player.body:getY(), nil, player.direction, 1,
        util.getCenter(player.sprite:getWidth()), util.getCenter(player.sprite:getHeight()))

    drawCoins()
    cam:detach()
end

function spawnPlatform(x, y, width, height)
    local platform = {}
    platform.body = lp.newBody(myWorld, x, y, 'static')
    platform.shape = lp.newRectangleShape(width / 2, height / 2, width, height)
    platform.fixture = lp.newFixture(platform.body, platform.shape)
    platform.width = width
    platform.height = height

    table.insert(platforms, platform)
end

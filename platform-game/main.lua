local util = require("util")

local lg = love.graphics

function love.load()
    sprites = {
        coin = "coin_sheet.png",
        jump = "player_jump.png",
        stand = "player_stand.png",
    }

    for i, image in sprites do
        sprites[i] = lg.newImage(image)
    end

end

function love.update(dt)
end

function love.draw()
end


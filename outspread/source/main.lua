require("colony")
require("ant")
require("nest")
require("global")

local blackNest = Nest:create(1, 100, 50, 20)
local redNest = Nest:create(2, lg.getWidth() - 20, 1000, 20)

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

    -- red location
    lg.draw(terrainSprites.terrain, redNest.graphic, redNest.x, redNest.y, nil, .4, .4)

    -- black location
    lg.draw(terrainSprites.terrain, blackNest.graphic, blackNest.x, blackNest.y, nil, .4, .4)

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


require("global")

local Colony = require("entities/Colony")
local Food = require("entities/Food")
local Control = require("entities/Control")

Colony({
    type = 1,
    x = 200,
    y = 600,
    population = 100
})

local food = Food({
    type = 1,
    x = 500,
    y = 500,
    amount = 100
})

local maxZoom = 4
local maxOut = .5
local control = Control({ panspeed = 300 })

function love.load()
    background = love.graphics.newImage("images/background/background.png")
    background:setWrap("repeat", "repeat")
    bg_quad = lg.newQuad(0, 0, lg.getWidth(), lg.getHeight(), background:getWidth(), background:getHeight())
    cam:zoom(1)
end

function love.update(dt)
    world:update(dt)

    for _, colony in ipairs(Colony) do
        for _, ant in ipairs(colony.nest.ants) do
            ant:update(dt)

            if ant.hasFood then
                ant.target = colony.nest
            else
                ant.target = food
            end

            if util.distanceBetween(ant.body:getX(), ant.body:getY(), food.x, food.y) < 1 then
                ant.hasFood = true
                food.amount = food.amount - 1
            end

            if util.distanceBetween(ant.body:getX(), ant.body:getY(), colony.nest.x, colony.nest.y) < 10 then
                ant.hasFood = false
                colony.nest.collectedFood = colony.nest.collectedFood + 1
            end

            ant.body:setX(ant.body:getX() - math.cos(util.getAngle(ant.target.y, ant.body:getX(), ant.target.x, ant.body:getX())) * ant.speed * dt)
            ant.body:setY(ant.body:getY() - math.sin(util.getAngle(ant.target.y, ant.body:getY(), ant.target.x, ant.body:getY())) * ant.speed * dt)
        end
    end

    if love.mouse.isDown(1) then
    end


    control:update(dt)
end

function love.draw()
    cam:attach()
    lg.draw(background, bg_quad, 0, 0)

    -- Later to come with tilemaps
    food:draw()

    -- draw ants
    for _, colony in ipairs(Colony) do
        colony.nest:draw()
        for _, ant in ipairs(colony.nest.ants) do
            ant:draw()
        end
    end

    cam:detach()
end

-- love specific
function love.wheelmoved(x, y)
    if y > 0 and cam.scale < maxZoom then
        cam:zoom(1.05)
    elseif y < 0 and cam.scale > maxOut then
        cam:zoom(.95)
    end
end


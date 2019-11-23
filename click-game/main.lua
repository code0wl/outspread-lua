function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
end

function love.load()
    button = {}
    button.x = 200
    button.y = 200
    button.size = 50

    score = 0
    timer = 10

    gameState = 1

    myFont = love.graphics.newFont(50)
end

function love.update(dt)
    if gameState == 2 then
        if timer > 0 then
            timer = timer - dt
        end

        if timer < 0 then
            timer = 0
            gameState = 1

        end
    end
end

function love.draw()
    if gameState == 2 then
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", button.x, button.y, button.size)
    end

    love.graphics.setFont(myFont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(score, 0 ,0 , 'center')
    love.graphics.print(math.ceil(timer), love.graphics.getWidth() / 2)

    if gameState == 1 then
        love.graphics.printf('click anywhere to start', 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), 'center')
    end
end

function love.mousepressed(x, y, b, istouch)
    if b == 1 and gameState == 2 then
        if distanceBetween(x, y, button.x, button.y) - button.size < 0 then
            score = score + 1

            button.x = math.random(button.size, love.graphics.getWidth() - button.size)
            button.y = math.random(button.size, love.graphics.getHeight() - button.size)
        end
    end
    if gameState == 1 then
        gameState = 2
        timer = 10
        score = 0
    end
end

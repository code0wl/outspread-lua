function love.load()
    sprites = {}
    sprites.player = love.graphics.newImage("sprites/player.png")
    sprites.zombie = love.graphics.newImage("sprites/zombie.png")
    sprites.bullet = love.graphics.newImage("sprites/bullet.png")
    sprites.background = love.graphics.newImage("sprites/background.png")

    player = {}
    player.x = 200
    player.y = 200
    player.speed = 180
    player.r = 0
    player.width = 43
    player.height = 43

    zombies = {}
    bullets = {}
end

function spawnBullet()
    local bullet = {}
    bullet.y = player.y
    bullet.x = player.x
    bullet.speed = 0
    bullet.width = 64
    bullet.height = 64
    bullet.direction = player.r

    table.insert(bullets, bullet)
end

function spawnZombie()
    local zombie = {}
    zombie.x = math.random(0, love.graphics.getWidth())
    zombie.width = 43
    zombie.height = 43
    zombie.y = math.random(0, love.graphics.getHeight())
    zombie.r = 0
    zombie.speed = 100
    table.insert(zombies, zombie)
end

function love.update(dt)

    local playerSpeed = player.speed * dt

    player.r = love.mouse.getPosition()

    if love.keyboard.isDown("w") and player.y > 1 then
        player.y = player.y - playerSpeed
    end

    if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then
        player.y = player.y + playerSpeed
    end

    if love.keyboard.isDown("a") and player.x > 1 then
        player.x = player.x - playerSpeed
    end

    if love.keyboard.isDown("d") and player.x < love.graphics.getHeight() then
        player.x = player.x + playerSpeed
    end

    for i, z in ipairs(zombies) do
        z.x = z.x - math.cos(getAngle(player, z)) * z.speed * dt
        z.y = z.y - math.sin(getAngle(player, z)) * z.speed * dt

        if distanceBetween(player.x, player.y, z.x, z.y) < 5 then
            newGame()
        end
    end

    local mouseVector = {
        x = love.mouse.getX(),
        y = love.mouse.getY()
    }

    player.rotation = getAngle(player, mouseVector)
end

function newGame()
    for k in pairs(zombies) do
        zombies[k] = nil
    end

    player.x = getCenter(love.graphics.getWidth())
    player.y = getCenter(love.graphics.getHeight())
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)

    for i, z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, getAngle(player, z) + math.pi, nil, nil, getCenter(z.width), getCenter(z.height))
    end

    for i, b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, .5, .5)
    end

    love.graphics.draw(sprites.player, player.x, player.y, player.rotation, nil, nil, getCenter(player.width), getCenter(player.height))
end

function getCenter(value)
    return value / 2
end

function getAngle(player, vector)
    return math.atan2(player.y - vector.y, player.x - vector.x) + math.pi
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
end

function love.keypressed(key)
    if key == "space" then
        spawnZombie()
    end
end

function love.mousepressed(x, y, b, istouch)
    if b == 1 then
        spawnBullet()
    end
end
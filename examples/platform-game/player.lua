player = {}
player.body = lp.newBody(myWorld, 100, 100, 'dynamic')
player.shape = lp.newRectangleShape(66, 92)
player.fixture = lp.newFixture(player.body, player.shape)
player.speed = 200
player.grounded = false
player.direction = 1
player.sprite = graphics.jump
player.body:setFixedRotation(true)

function player.update(dt)
    local speed = player.speed * dt
    if love.keyboard.isDown("right") then
        player.direction = 1
        player.body:setX(player.body:getX() + speed)
    end

    if love.keyboard.isDown("left") then
        player.direction = -1
        player.body:setX(player.body:getX() - speed)
    end
end

function love.keypressed(key)
    if key == 'space' and player.grounded then
        player.body:applyLinearImpulse(0, -4500)
    end
end

function beginContact(a, b, coll)
    player.grounded = true
    player.sprite = graphics.stand
end

function endContact(a, b, coll)
    player.grounded = false
    player.sprite = graphics.jump
end
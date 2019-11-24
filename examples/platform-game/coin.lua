coins = {}

function spawnCoin(x, y)
    local coin = {}
    coin.x = x
    coin.y = y
    coin.collected = false

    coin.grid = anim8.newGrid(41, 42, graphics.coin:getWidth(), graphics.coin:getHeight())
    coin.animation = anim8.newAnimation(coin.grid('1-3', 1, '1-3', 2, '1-2', 3), 0.2)

    table.insert(coins, coin)
end

function coinUpdate(dt)
    for i, c in ipairs(coins) do
        c.animation:update(dt)
        if util.distanceBetween(c.x, c.y, player.body:getX(), player.body:getY()) < 100 then
            c.collected = true
        end
    end

    for i = #coins, 1, -1 do
        local c = coins[i]
        if c.collected then
            table.remove(coins, i)
        end
    end
end

function drawCoins()
    for i, c in ipairs(coins) do
        c.animation:draw(graphics.coin, c.x, c.y, nil, nil, nil, 20.5, 21)
    end
end


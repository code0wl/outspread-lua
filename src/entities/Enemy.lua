local Enemy = {}

function Enemy:new()
    local enemy = setmetatable({}, {__index = Enemy})
    enemy.isAlive = true
    enemy.x = -1000
    enemy.y = -1000
    return enemy
end

function Enemy:draw()
    --  noop
end

function Enemy:hunt(animal)
    --  noop
end

function Enemy:update(dt)
    -- noop
end

return Enemy


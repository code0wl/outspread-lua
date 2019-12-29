local util = {}

function util.getCenter(value) return value / 2 end

function util.getAngle(y1, y2, x1, x2) return math.atan2(y1 - y2, x1 - x2) end

function util.distanceBetween(x1, y1, x2, y2)
    return math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
end

function util.travelRandomly()
    return math.random(GlobalWidth, 0), math.random(GlobalHeight, 0)
end

function util.travelRandomlyOffScreen()
    return math.random(-GlobalWidth, 0), math.random(-GlobalHeight, 0)
end

function util.generateRandomInteger(min, max)
    return math.floor(math.random() * (max - min + 1)) + min
end

function util.isOutOfBounds(x, y)
    return x < 0 or y < 0 or x > GlobalWidth or y > GlobalHeight
end

function util.setDirection(actorX, actorY, velocity, target, dt)
    local angle = util.getAngle(target.y, actorY, target.x, actorX)
    local cos = math.cos(angle)
    local sin = math.sin(angle)
    return actorX + velocity * cos * dt, actorY + velocity * sin * dt
end

return util

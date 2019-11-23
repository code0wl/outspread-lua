local util = {}

function util.getCenter(value)
    return value / 2
end

function util.getAngle(player, vector)
    return math.atan2(player.y - vector.y, player.x - vector.x) + math.pi
end

function util.distanceBetween(x1, y1, x2, y2)
    return math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
end

function util.isOutOfBounds(element)
    return element.x < 0 or element.y < 0 or element.x > love.graphics.getWidth() or element.y > love.graphics.getHeight()
end

return util
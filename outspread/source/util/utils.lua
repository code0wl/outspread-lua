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

function util.newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

return util
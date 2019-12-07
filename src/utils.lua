local util = {}

function util.getCenter(value) return value / 2 end

function util.getAngle(y1, y2, x1, x2)
    return math.atan2(y1 - y2, x1 - x2) + math.pi
end

function util.distanceBetween(x1, y1, x2, y2)
    return math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
end

-- CheckCollision with physics body
function util.CheckCollisionWithPhysics(body1, body2)
    return util.CheckCollision(body1.body:getX(), body1.body:getY(),
                               body1.width, body1.height, body2.body:getX(),
                               body2.body:getY(), body2.width, body2.height)

end

function util.generateRandomInteger(min, max)
    return math.floor(math.random() * (max - min + 1)) + min
end

function util.isOutOfBounds(element)
    return element.x < 0 or element.y < 0 or element.x > Lg.getWidth() or
               element.y > Lg.getHeight()
end

function util.CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function util.setDirectionToTarget(actor, dt)
    local speed = actor.speed * dt
    return (actor.x -
               math.cos(util.getAngle(actor.target.y, actor.x, actor.target.x,
                                      actor.x)) * speed), (actor.y -
               math.sin(util.getAngle(actor.target.y, actor.y, actor.target.x,
                                      actor.x)) * speed)

end

return util

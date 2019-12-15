local Food = require("entities.Food")

local util = {}

function util.dropFood(x, y, amount)
    table.insert(FoodCollection, Food:new({x = x, y = y, amount = amount}))
end

function util.dropFoodOnMap(type, x, y, height, width, angle, actor)
    table.insert(FoodCollection, actor:new(
                     {
            type = type,
            x = x,
            y = y,
            width = width,
            height = height,
            angle = angle
        }))
end

function util.getCenter(value) return value / 2 end

local pi = math.pi
function util.getAngle(y1, y2, x1, x2) return math.atan2(y1 - y2, x1 - x2) + pi end

function util.distanceBetween(x1, y1, x2, y2)
    return math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
end

function util.travelRandomly()
    return {x = math.random(GlobalWidth, 0), y = math.random(GlobalHeight, 0)}
end

function util.travelRandomlyOffScreen()
    return {x = math.random(-GlobalWidth, 0), y = math.random(-GlobalHeight, 0)}
end

function util.generateRandomInteger(min, max)
    return math.floor(math.random() * (max - min + 1)) + min
end

function util.isOutOfBounds(element)
    return element.x < 0 or element.y < 0 or element.x > Lg.getWidth() or
               element.y > Lg.getHeight()
end

function util.setDirectionToTarget(actor, dt)
    local speed = actor.speed * dt
    return (actor.x -
               math.cos(util.getAngle(actor.target.y, actor.x, actor.target.x,
                                      actor.x)) * speed), (actor.y -
               math.sin(util.getAngle(actor.target.y, actor.y, actor.target.x,
                                      actor.x)) * speed)

end

function util.signal(foodSignalSize, foodSignalActive, aggressionSignalSize,
                     aggressionSignalActive)
    return {
        foodSignalSize = foodSignalSize,
        foodSignalActive = foodSignalActive,
        aggressionSignalSize = aggressionSignalSize,
        aggressionSignalActive = aggressionSignalActive
    }
end

return util

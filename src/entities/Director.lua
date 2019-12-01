local Director = {}

-- prey check
function Director.checkPreyCollision(prey, predator)
    return util.CheckCollision(prey.body:getX(), prey.body:getY(), prey.width,
                               prey.height, predator.body:getX(),
                               predator.body:getY(), predator.width,
                               predator.height)

end

return Director

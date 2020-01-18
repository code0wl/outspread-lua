local Levels = {
    {
        location = {x = 40, y = util.getCenter(Lg.getHeight()) - 30},
        predators = {},
        rivals = 5,
        population = 200,
        background = BackgroundRocks
    },
    {
        location = {x = util.getCenter(Lg.getWidth()) + 400, y = util.getCenter(Lg.getWidth()) - 400},
        predators = {},
        rivals = 10,
        population = 200,
        background = BackgroundImageGrass
    }
}

return Levels

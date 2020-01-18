local Levels = {
    -- level 1
    {
        location = {x = 40, y = util.getCenter(Lg.getHeight()) - 30},
        predators = {},
        rivals = {
            type = 2,
            x = 600,
            y = 600,
            population = 1000,
            width = 50,
            height = 50
        },
        colony = {
            type = 1,
            x = 100,
            y = 200,
            population = 1000,
            width = 50,
            height = 50
        },
        background = BackgroundRocks
    }

    -- level 2
}

return Levels

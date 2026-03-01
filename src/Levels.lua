local SpiderTarantula = require("entities.SpiderTarantula")

local Levels = {
    -- level 1
    {
        name          = "The Home Warren",
        location      = { x = 40, y = util.getCenter(Lg.getHeight()) - 30 },
        isAccessible  = true,
        initialStatus = "accessible",
        predators     = {
            {
                type = SpiderTarantula,
                x = 2000,
                y = 1250
            }
        },
        rivals        = {
            type = 2,
            x = 3700,
            y = 1250,
            population = 500,
            width = 50,
            height = 50
        },
        colony        = {
            type = 1,
            x = 150,
            y = 1250,
            population = 500,
            width = 50,
            height = 50
        },
        background    = BackgroundDirt
    },
    -- level 2
    {
        name          = "The Amber Flats",
        location      = { x = 240, y = util.getCenter(Lg.getHeight()) + 50 },
        isAccessible  = false,
        initialStatus = "undiscovered",
        predators     = {},
        rivals        = {
            type = 2,
            x = 3200,
            y = 1250,
            population = 300,
            width = 50,
            height = 50
        },
        colony        = {
            type = 1,
            x = 150,
            y = 1250,
            population = 500,
            width = 50,
            height = 50
        },
        background    = BackgroundDirt
    },
    -- level 3
    {
        name          = "Dust Basin",
        location      = { x = 440, y = util.getCenter(Lg.getHeight()) - 80 },
        isAccessible  = false,
        initialStatus = "undiscovered",
        predators     = {},
        rivals        = {
            type = 2,
            x = 2800,
            y = 1250,
            population = 400,
            width = 50,
            height = 50
        },
        colony        = {
            type = 1,
            x = 150,
            y = 1250,
            population = 500,
            width = 50,
            height = 50
        },
        background    = BackgroundDirt
    },
    -- level 4
    {
        name          = "The Red Citadel",
        location      = { x = 640, y = util.getCenter(Lg.getHeight()) + 10 },
        isAccessible  = false,
        initialStatus = "undiscovered",
        predators     = {},
        rivals        = {
            type = 2,
            x = 2400,
            y = 1250,
            population = 600,
            width = 50,
            height = 50
        },
        colony        = {
            type = 1,
            x = 150,
            y = 1250,
            population = 500,
            width = 50,
            height = 50
        },
        background    = BackgroundDirt
    }
}

return Levels

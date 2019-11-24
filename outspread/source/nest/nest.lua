Nest = {}

function Nest:create(type, x, y, population)

    local nest = {}
    nest.type = type
    nest.population = population
    nest.x = x
    nest.y = y
    nest.width = 16
    nest.height = 27
    nest.population = true
    nest.graphic = lg.newQuad(300, 70, 80, 80, terrainSprites.terrain:getDimensions())

    for i = 0, population do
        Ant:create(nest.type, x + i, y + i, 1)
    end

    return nest
end



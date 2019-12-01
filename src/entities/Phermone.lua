local Phermone = {}

function Phermone(antConfig)
    local phermone = {}

    phermone.type = antConfig.type

    phermone.x = antConfig.x
    phermone.y = antConfig.y
    ant.width = 16
    ant.height = 27
    ant.isActive = true

    function phermone.update(dt) end

    function phermone.draw() end

    return phermone

end

return Phermone


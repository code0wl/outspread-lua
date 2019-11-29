local Ant = {}

function Ant(antConfig)
    local ant = {}

    ant.state = antConfig.state
    ant.type = antConfig.type

    ant.images = {
        lg.newImage("images/ants/spritesheets/ant" .. ant.type ..
                        "/_ant_walk-small.png"),
        lg.newImage("images/ants/spritesheets/ant" .. ant.type ..
                        "/_ant_dead-small.png")
    }

    ant.x = math.random() * 2 * antConfig.x
    ant.y = math.random() * 2 * antConfig.y
    ant.isAnt = true
    ant.hasFood = nil
    ant.currentState = ant.images[ant.state]
    ant.speed = 60
    ant.width = 16
    ant.height = 27

    ant.alive = true
    ant.grid = anim8.newGrid(ant.width, ant.height, ant.currentState:getWidth(),
                             ant.currentState:getHeight() + 1)
    ant.animation = anim8.newAnimation(ant.grid('1-5', 1, '1-5', 2, '1-5', 3),
                                       0.04)

    function ant.update(dt)
        ant.animation:update(dt)
    end

    function ant.draw()
        ant.animation:draw(ant.currentState, ant.x, ant.y, util.getAngle(
                               ant.target.y, ant.y, ant.target.x, ant.x) + 1.6 +
                               math.pi, .5, .5, util.getCenter(ant.width),
                           util.getCenter(ant.height))

        if ant.hasFood then
            ant.speed = 40
            lg.setColor(255, 153, 153)
            lg.circle("fill", ant.x, ant.y, 2, 10)
        end
    end

    return ant
end

return Ant


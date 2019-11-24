Ant = {}

function Ant:create(type, x, y, state)
    local ant = {}
    ant.state = state
    ant.rotation = 0
    ant.type = type
    ant.images = {
        lg.newImage("images/ants/spritesheets/ant" .. type .. "/_ant_walk-small.png"),
        lg.newImage("images/ants/spritesheets/ant" .. type .. "/_ant_dead-small.png"),
    }
    ant.x = x
    ant.y = y
    ant.currentState = ant.images[ant.state]
    ant.speed = 200
    ant.width = 16
    ant.height = 27
    ant.direction = 1
    ant.alive = true
    ant.grid = anim8.newGrid(ant.width, ant.height, ant.currentState:getWidth(), ant.currentState:getHeight() + 1)
    ant.animation = anim8.newAnimation(ant.grid('1-5', 1, '1-5', 2, '1-5', 3), 0.04),
    table.insert(Colony[ant.type], ant)
end




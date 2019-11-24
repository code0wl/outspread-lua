Ant = {}

blackAnts = {}
redAnts = {}

function Ant:create(type, x, y)
    local ant = {}
    ant.type = type
    ant.images = {
        walk = lg.newImage("images/ants/spritesheets/ant" .. ant.type .. "/_ant_walk-small.png"),
        dead = lg.newImage("images/ants/spritesheets/ant" .. ant.type .. "/_ant_dead-small.png"),
        idle = lg.newImage("images/ants/spritesheets/ant" .. ant.type .. "/_ant_idle-small.png")
    }
    ant.x = x
    ant.y = y
    ant.currentState = ant.images.walk
    ant.body = lp.newBody(antWorld, 100, 100, "dynamic")
    ant.shape = lp.newRectangleShape(15, 27)
    ant.fixture = lp.newFixture(ant.body, ant.shape)
    ant.speed = 200
    ant.direction = 1
    ant.alive = true
    ant.body:setFixedRotation(true)
    ant.grid = anim8.newGrid(16, 27, ant.currentState:getWidth(), ant.currentState:getHeight() + 1)
    ant.animation = anim8.newAnimation(ant.grid('1-5', 1, '1-5', 2, '1-5', 3), 0.04)
    if type == 1 then
        table.insert(blackAnts, ant)
    else
        table.insert(redAnts, ant)
    end
    return ant
end




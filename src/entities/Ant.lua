local Ant = {}

function Ant:new(antConfig)
    local ant = setmetatable({}, {__index = Ant})

    ant.type = antConfig.type

    ant.image = lg.newImage("images/ants/spritesheets/ant" .. ant.type ..
                                "/_ant_walk-small.png")

    ant.x, ant.y = Component.position(antConfig.x, antConfig.y)
    ant.nest = {x = antConfig.x, y = antConfig.y}
    ant.hasFood = nil
    ant.speed = 90
    ant.width = 16
    ant.height = 27
    ant.target = nil
    ant.isAlive = true
    ant.scentLocation = nil

    -- Physics
    ant.body = lp.newBody(world, ant.x, ant.y, "dynamic")
    ant.shape = lp.newRectangleShape(4, 4)
    ant.fixture = lp.newFixture(ant.body, ant.shape, .5)
    ant.body:setSleepingAllowed(true)

    -- Signal first draft
    ant.signal = {radius = 100, active = false}

    ant.grid = anim8.newGrid(ant.width, ant.height, ant.image:getWidth(),
                             ant.image:getHeight() + 1)

    ant.animation = anim8.newAnimation(ant.grid('1-5', 1, '1-5', 2, '1-5', 3),
                                       0.04)

    return ant

end

function Ant:update(foodCollection, target, dt, spider)
    self.animation:update(dt)
    self:setTarget(target, spider, dt)
    self:handleFood(foodCollection)
end

function Ant:returnFoodToNest(target)
    if self.hasFood then
        if util.distanceBetween(self.body:getX(), self.body:getY(), target.x,
                                target.y) < 45 then
            self.hasFood = false
            target.collectedFood = target.collectedFood + 1
        end
    end
end

function Ant:draw()
    self.animation:draw(self.image, self.body:getX(), self.body:getY(),
                        util.getAngle(self.target.y, self.body:getY(),
                                      self.target.x, self.body:getX()) + 1.6 +
                            math.pi, .4, .4, util.getCenter(self.width),
                        util.getCenter(self.height))

    if self.hasFood then
        self.speed = 60
        lg.setColor(255, 153, 153)
        lg.circle("fill", self.body:getX(), self.body:getY(), 2)
    end

    if self.signal.active then
        lg.circle('line', self.body:getX(), self.body:getY(), self.signal.radius)
    end

end

function Ant:setTarget(target, spider, dt)
    timePassed = timePassed + 1 * dt

    if self.hasFood then self.target = self.nest end

    -- Walk randomnly
    if timePassed > 2 or self.target == nil then
        timePassed = 0
        self.target = {
            x = math.random(globalWidth, 0),
            y = math.random(globalHeight, 0)
        }
    end

    -- Follow scent
    if not self.hasFood and self.scentLocation then
        self.target = self.scentLocation
    end

    -- if scent is spider
    local spiderX = spider.body:getX()
    local spiderY = spider.body:getY()
    if not self.hasFood and
        util.distanceBetween(self.body:getX(), self.body:getY(), spiderX,
                             spiderY) < self.signal.radius then
        self.target = {x = spiderX, y = spiderY}
    end

    -- deliver food to nest
    self:returnFoodToNest(target)

    util.setDirectionToTarget(self, dt)
end

function Ant:handleFood(food)
    for i, f in ipairs(food) do
        if not self.hasFood and
            util.distanceBetween(self.body:getX(), self.body:getY(), f.x, f.y) <
            f.amount then
            self.hasFood = true
            self.scentLocation = f
            self.signal.active = true
            f.amount = f.amount - 1
        elseif self.scentLocation and self.scentLocation.amount < 1 then
            self.scentLocation = nil
            self.signal.active = false
        end
    end
end

return Ant


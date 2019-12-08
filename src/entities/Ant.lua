local Ant = {}

function Ant:new(antConfig)
    local ant = setmetatable({}, {__index = Ant})

    ant.type = antConfig.type

    ant.image = Lg.newImage("images/ants/spritesheets/ant" .. ant.type ..
                                "/_ant_walk-small.png")

    ant.x, ant.y = Component.position(antConfig.x, antConfig.y)
    ant.nest = {x = antConfig.x, y = antConfig.y}
    ant.hasFood = nil
    ant.speed = 90
    ant.width = 16
    ant.damage = 1
    ant.height = 27
    ant.target = nil
    ant.isAlive = true
    ant.scentLocation = nil

    -- Signal first draft
    ant.signal = Component.signal(100, false, 150, false)

    ant.grid = anim8.newGrid(ant.width, ant.height, ant.image:getWidth(),
                             ant.image:getHeight() + 1)

    ant.animation = anim8.newAnimation(ant.grid('1-5', 1, '1-5', 2, '1-5', 3),
                                       0.04)

    return ant

end

function Ant:update(foodCollection, target, dt)
    self.animation:update(dt)
    self:setTarget(target, dt)
    self:handleFood(foodCollection)
end

function Ant:returnFoodToNest(nest)
    if self.hasFood and util.distanceBetween(self.x, self.y, nest.x, nest.y) <
        45 then
        self.hasFood = false
        nest:addFood()
    end
end

function Ant:draw()
    self.animation:draw(self.image, self.x, self.y,
                        util.getAngle(self.target.y, self.y, self.target.x,
                                      self.x) + 1.6 + math.pi, .4, .4,
                        util.getCenter(self.width), util.getCenter(self.height))

    -- Attach food particle to ant once has food
    if self.hasFood then
        Lg.setColor(255, 153, 153)
        Lg.circle("fill", self.x, self.y, 2)
    end

end

function Ant:attack(animal) animal.health = animal.health - self.damage end

function Ant:setTarget(target, dt)

    TimePassedAnt = TimePassedAnt + 1 * dt

    if self.hasFood then self.target = self.nest end

    -- Walk randomnly
    if TimePassedAnt > 2 or self.target == nil then
        TimePassedAnt = 0
        self.target = {
            x = math.random(GlobalWidth, 0),
            y = math.random(GlobalHeight, 0)
        }
    end

    -- Follow scent
    if not self.hasFood and self.scentLocation then
        self.target = self.scentLocation
    end

    -- deliver food to nest
    self:returnFoodToNest(target)

    self.x, self.y = util.setDirectionToTarget(self, dt)
end

function Ant:handleFood(food)
    for _, f in ipairs(food) do
        if not self.hasFood and util.distanceBetween(self.x, self.y, f.x, f.y) <
            f.amount then
            self.hasFood = true
            self.scentLocation = f
            self.signal.foodSignalActive = true
            f:removeOneFood()
        elseif self.scentLocation and self.scentLocation.amount < 1 then
            self.scentLocation = nil
            self.signal.foodSignalActive = false
        end
    end
end

return Ant

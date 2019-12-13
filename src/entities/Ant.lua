local Actor = require('entities.Actor')
local Ant = class('Ant', Actor)

function Ant:initialize(antConfig)
    Actor.initialize(self)

    self.antConfig = antConfig

    self.type = self.antConfig.type

    self.x, self.y = Component.position(self.antConfig.x, self.antConfig.y)
    self.nest = {x = self.antConfig.x, y = self.antConfig.y}
    self.hasFood = nil

    self.target = {x = self.antConfig.x, y = self.antConfig.y}
    self.scentLocation = nil

    -- Signal first draft
    self.signal = Component.signal(100, false, 150, false)

end

function Ant:update(foodCollection, target, dt)
    if self.isAlive then
        if self.health < 1 then self.isAlive = false end
        self.animation:update(dt)
        self:setTarget(target, dt)
        self:handleFood(foodCollection)
    end
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
    if not self.aggressionSignalActive and TimePassedAnt > 2 then
        TimePassedAnt = 0
        self.target = util.travelRandomly()
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

-- deals with non ant aggressors
function Ant:handleAggressor(otherCreature)

    if not self.hasFood and
        util.distanceBetween(self.x, self.y, otherCreature.x, otherCreature.y) <
        self.signal.aggressionSignalSize then
        self.target = {x = otherCreature.x, y = otherCreature.y}
        self.signal.aggressionSignalActive = true
    else
        self.signal.aggressionSignalActive = false
    end

    self:attackAggressor(otherCreature)
end

function Ant:attackAggressor(otherCreature)
    if self.signal and self.signal.aggressionSignalActive and
        util.distanceBetween(self.x, self.y, otherCreature.x, otherCreature.y) <
        otherCreature.width then self:attack(otherCreature) end
end

return Ant

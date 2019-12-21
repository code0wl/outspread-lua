local Actor = require('entities.Actor')
local Ant = class('Ant', Actor)

function Ant:initialize(antConfig)
    Actor.initialize(self)

    self.antConfig = antConfig

    self:add(Components.Signal(100, false, 150, false))
    self:add(Components.Position(self.antConfig.x, self.antConfig.y))
    self:add(Components.Velocity(80))

    -- Delta for nest location
    self.nest = Components.Position(self.antConfig.x, self.antConfig.y)

    self.type = self.antConfig.type
    self.hasFood = nil

    self.target = self.nest

    self.scentLocation = nil

end

function Ant:update(foodCollection, target, dt)

    self.animation:update(dt)
    self:setTarget(target, dt)
    self:handleFood(foodCollection)

end

function Ant:returnFoodToNest(nest)
    local position = self:get('position')
    if self.hasFood and
        util.distanceBetween(position.x, position.y, nest:get("position").x,
                             nest:get("position").y) < 45 then
        self.hasFood = false
        nest:addFood()
    end
end

function Ant:draw()
    local position = self:get('position')
    
    self.animation:draw(self.image, position.x, position.y, self.angle, .4, .4,
                        util.getCenter(self:get('dimension').width),
                        util.getCenter(self:get('dimension').height))

    -- Attach food particle to ant once has food
    if self.hasFood then
        Lg.setColor(255, 153, 153)
        Lg.circle("fill", position.x, position.y, 2)
    end

end

function Ant:dropFood()
    self.hasFood = false
    self.scentLocation = false
end

function Ant:setTarget(target, dt)
    local position = self:get('position')
    local velocity = self:get('velocity')

    TimePassedAnt = TimePassedAnt + 1 * dt

    if self.hasFood then self.target = self.nest end

    -- Walk randomnly
    if not self.aggressionSignalActive and TimePassedAnt > 2 then
        TimePassedAnt = 0
        self.target = Components.Position(util.travelRandomly())
    end

    -- Follow scent
    if not self.hasFood and self.scentLocation then
        self.target = Components.Position(self.scentLocation.x, self.scentLocation.y)
    end

    -- deliver food to nest
    self:returnFoodToNest(target)

    position.x, position.y = util.setDirection(
        position.x,
        position.y,
        velocity.speed,
        self.target, 
        dt
    )

    
    self.angle = util.getAngle(self.target.y, position.y, self.target.x, position.x) +
                     1.6 + math.pi
end

function Ant:handleFood(food)
    local position = self:get('position')

    for _, f in ipairs(food) do

        -- remove me once everything is migrated
        local x, y = f:get("position").x, f:get("position").y

        if not self.hasFood and util.distanceBetween(position.x, position.y, f.x, f.y) <
            f:get('dimension').width then
            self.hasFood = true
            self.scentLocation = Components.Position(f:get("position").x, f:get("position").y)
            self.signal.foodSignalActive = true
            f:removeFood()
        elseif self.scentLocation then
            self.scentLocation = nil
            self.signal.foodSignalActive = false
        end
    end
end

-- deals with non ant aggressors
function Ant:handleAggressor(otherCreature)
    local position = self:get('position')

    local x, y = otherCreature:get("position").x, otherCreature:get("position").y

    if not self.hasFood and util.distanceBetween(position.x, position.y, x, y) <
        self:get("signal").aggressionSignalSize then
        self.target = Components.Position(x, y)
        self:get("signal").aggressionSignalActive = true
    else
        self:get("signal").aggressionSignalActive = false
    end

    self:attackAggressor(x, y, otherCreature:get('dimension').width,
                         otherCreature)
end

function Ant:attackAggressor(x, y, width, otherCreature)
    if self:get("signal").aggressionSignalActive and
        util.distanceBetween(self:get("position").x, self:get("position").y, x, y) < width then
        self:attack(otherCreature)
    end
end

return Ant

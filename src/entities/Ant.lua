local Actor = require('entities.Actor')
local Ant = class('Ant', Actor)

function Ant:initialize(antConfig)
    Actor.initialize(self)

    self.TimePassedAnt = 0

    self:add(Components.Velocity(80))
    self:add(Components.Scale(.4))
    self:add(Components.Animation(true))
    self:add(Components.Ant(true, antConfig.type))

    -- Delta for nest location
    self.nest = Components.Position(antConfig.x, antConfig.y)
    self.target = Components.Position(antConfig.x, antConfig.y)
    self.hasFood = nil
    self.scentLocation = nil

    self.fixture:setUserData(antConfig.type)

    self.body:setPosition(antConfig.x, antConfig.y)
end

-- function Ant:returnFoodToNest(nest)
--     local position = self:get('position')
--     if self.hasFood and
--         util.distanceBetween(position.x, position.y, nest:get("position").x,
--                              nest:get("position").y) < 45 then
--         self.hasFood = false
--         nest:addFood()
--     end
-- end

-- function Ant:dropFood()
--     self.hasFood = false
--     self.scentLocation = false
-- end

-- function Ant:handleFood(food)
--     local position = self:get('position')

--     for _, f in ipairs(food) do

--         -- remove me once everything is migrated
--         local x, y = f:get("position").x, f:get("position").y

--         if not self.hasFood and util.distanceBetween(position.x, position.y, f.x, f.y) <
--             f:get('dimension').width then
--             self.hasFood = true
--             self.scentLocation = Components.Position(f:get("position").x, f:get("position").y)
--             self.signal.foodSignalActive = true
--             f:removeFood()
--         elseif self.scentLocation then
--             self.scentLocation = nil
--             self.signal.foodSignalActive = false
--         end
--     end
-- end

-- -- deals with non ant aggressors
-- function Ant:handleAggressor(otherCreature)
--     local position = self:get('position')

--     local x, y = otherCreature:get("position").x, otherCreature:get("position").y

--     if not self.hasFood and util.distanceBetween(position.x, position.y, x, y) <
--         self:get("signal").aggressionSignalSize then
--         self.target = Components.Position(x, y)
--         self:get("signal").aggressionSignalActive = true
--     else
--         self:get("signal").aggressionSignalActive = false
--     end

--     self:attackAggressor(x, y, otherCreature:get('dimension').width,
--                          otherCreature)
-- end

-- function Ant:attackAggressor(x, y, width, otherCreature)
--     if self:get("signal").aggressionSignalActive and
--         util.distanceBetween(self:get("position").x, self:get("position").y, x, y) < width then
--         self:attack(otherCreature)
--     end
-- end

return Ant

local Actor = require('entities.Actor')
local Ant = class('Ant', Actor)

function Ant:initialize(antConfig)
    Actor.initialize(self)

    self:add(Components.Ant(true))
    self:add(Components.Animation(true))
    self.TimePassedAnt = 0
    self.type = antConfig.type
    self.hasFood = false
    self.nest = antConfig.nest

    if self.type == 1 then
        self.image = BlackWalk
        local grid =  anim8.newGrid(16, 27, BlackWalk:getWidth(),
        BlackWalk:getHeight() + 1)
        self:add(Components.Player(true))
        self.animation = anim8.newAnimation(grid('1-5', 1, '1-5',
        2, '1-5', 3),
0.04)
    else
        self.image = RedWalk
        local grid =  anim8.newGrid(16, 27, RedWalk:getWidth(),
        RedWalk:getHeight() + 1)
        self.animation = anim8.newAnimation(grid('1-5', 1, '1-5', 2,
        '1-5', 3), 0.04)
    end

    -- Delta for nest location
    self.nestPosition = antConfig.nest:get('position')
    self.target = self.nestPosition
    self:add(Components.Position(self.nestPosition.x, self.nestPosition.y))
end

function Ant:carry(actor)
    actor:get('food').amount = actor:get('food').amount - 1
end

function Ant:collectFood(animal)
    self:get("food").amount = self:get("food").amount - animal.carryCapacity
end

return Ant

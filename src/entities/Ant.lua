local Actor = require("entities.Actor")
local Ant = class("Ant", Actor)

local function createAnt(image)
    local grid = anim8.newGrid(26, 16, image:getWidth(), image:getHeight() + 3)
    return anim8.newAnimation(grid("1-3", 1, "1-3", 2), 0.1)
end

function Ant:initialize(antConfig)
    Actor.initialize(self)

    self:add(Components.Ant(true))
    self:add(Components.Animation(true))
    self.TimePassedAnt = 0
    self.type = antConfig.type
    self.hasFood = false
    self.nest = antConfig.nest

    -- Delta for nest location
    self.nestPosition = antConfig.nest:get("position")
    self.target = self.nestPosition
    self:add(Components.Position(self.nestPosition.x, self.nestPosition.y))

    if self.type == 1 then
        self.image = BlackWalk
        self:add(Components.Player(true))
        self.animation = createAnt(BlackWalk)
    else
        self.image = RedWalk
        self.animation = createAnt(RedWalk)
    end
end

function Ant:carry(actor)
    actor:get("food").amount = actor:get("food").amount - 1
end

function Ant:collectFood(animal)
    self:get("food").amount = self:get("food").amount - animal.carryCapacity
end

return Ant

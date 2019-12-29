local WorkerAnt = require("entities/WorkerAnt")
local SoldierAnt = require("entities/SoldierAnt")
local ScoutAnt = require("entities/ScoutAnt")

local Nest = class('Nest', Entity)

function Nest:initialize(nestConfig)
    Entity.initialize(self)

    self:add(Components.Position(nestConfig.x, nestConfig.y))
    self:add(Components.Dimension(16, 27))
    self:add(Components.Nest(true))
    self:add(Components.Scale(.4))
    self:add(Components.Static(true))
    self:add(Components.Food(0))

    self.ants = {soldiers = 0, workers = 0, scouts = 0}

    self.type = nestConfig.type
    self.graphic = Lg.newQuad(300, 70, 80, 80,
                              TerrainSprites.terrain:getDimensions())

    for i = 0, nestConfig.population do
        engine:addEntity(WorkerAnt:new({type = self.type, nest = self}))
    end

end

function Nest:receiveFood(amount) self:get('food').amount = self:get('food').amount + amount end

function Nest:update()
    for i = 0, self.ants.soldiers do
        self.ants.soldiers = self.ants.soldiers - 1
        engine:addEntity(SoldierAnt:new({type = self.type, nest = self}))
    end

    for i = 0, self.ants.scouts do
        self.ants.scouts = self.ants.scouts - 1
        engine:addEntity(ScoutAnt:new({type = self.type, nest = self}))
    end

    for i = 0, self.ants.workers do
        self.ants.workers = self.ants.workers - 1
        engine:addEntity(ScoutAnt:new({type = self.type, nest = self}))
    end

end

return Nest

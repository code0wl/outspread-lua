local Nest = class('Nest', Entity)

function Nest:initialize(nestConfig)
    Entity.initialize(self)

    self:add(Components.Position(nestConfig.x, nestConfig.y))
    self:add(Components.Dimension(16, 27))
    self:add(Components.Nest(true))
    self:add(Components.Scale(.4))
    self:add(Components.Static(true))
    self:add(Components.Food(0))

    self.ants = {soldiers = 0, workers = nestConfig.population, scouts = 0}

    self.type = nestConfig.type

    self.graphic = Lg.newQuad(300, 70, 80, 80,
                              TerrainSprites.terrain:getDimensions())

end

function Nest:receiveFood(amount) self:get('food').amount = self:get('food').amount + amount end

return Nest

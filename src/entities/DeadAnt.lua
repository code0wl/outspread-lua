local DeadAnt = class('DeadAnt')

function DeadAnt:initialize(deadAntConfig)

    self.type = deadAntConfig.type
    self.x = deadAntConfig.x
    self.y = deadAntConfig.y
    self.height = deadAntConfig.height
    self.width = deadAntConfig.width

    self.image = Lg.newImage("images/ants/spritesheets/ant" .. self.type ..
                                 "/_ant_dead-small.png")

end

function DeadAnt:draw() love.graphics.draw(self.image, self.width, self.height) end

return DeadAnt

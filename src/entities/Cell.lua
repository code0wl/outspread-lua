local Cell = class('Cell')

function Cell:initialize(size)
    self.width = size.width
    self.x = size.x
    self.y = size.y
    self.height = size.height
    self.nest = nil
    self.food = nil
    self.ant = nil
    self.spider = nil
end

function Cell:emptyCell()
    self.hasNest = nil
    self.hasFood = nil
    self.hasAnt = nil
    self.hasSpider = nil
end

return Cell


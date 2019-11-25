local Food = class("Ant")

function Food:init(type, x, y, amount)
    self.x = x
    self.y = y
    self.amount = amount
    self.type = type
end

return Food


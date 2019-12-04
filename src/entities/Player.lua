local Player = {hasDrawnPhermones = false, phermones = {}}

function Player:update(v)
    if table.getn(self.phermones) > 0 then print(inspect({1,2})) end
end

return Player


local Player = {hasDrawnPhermones = false, phermones = {}}

function Player:update(v)
    if table.getn(self.phermones) > 0 then print(inspect(self)) end
end

return Player


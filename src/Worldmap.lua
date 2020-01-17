local WorldMap = class("WorldMap")

function WorldMap:draw()
    local levels = {}
    local mouseX, mouseY = Lm.getPosition()
    Lg.draw(WorldMapBackground, 0, 0)
end

return WorldMap

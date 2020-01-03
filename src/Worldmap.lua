local WorldMap = class("WorldMap")

function WorldMap:initialize(worldMapConfig) self.tilesToRender = {} end

function WorldMap:load() print('loading world') end

return WorldMap


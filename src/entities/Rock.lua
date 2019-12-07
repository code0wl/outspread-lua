local Rock = {}

function Rock:new(rockConfig)
    local rock = setmetatable({}, {__index = Rock})
    rock.width = rockConfig.width
    rock.height = rockConfig.height
    rock.x = rockConfig.x
    rock.y = rockConfig.y
    return rock
end

function Rock:draw()
    Lg.setColor(255, 153, 153)
    Lg.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Rock

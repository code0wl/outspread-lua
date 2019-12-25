local Colony = require("entities.Colony")
local level1 = sti("levels/level-1.lua")

local asset = {}

function asset.generateWorldAssets()

    for _, obj in pairs(level1.layers["player_nest"].objects) do
        Colony:new({
            type = 1,
            x = obj.x,
            y = obj.y,
            population = 0,
            width = obj.width,
            height = obj.height
        })
    end

    -- for _, obj in pairs(level1.layers["enemy_nest"].objects) do
    --     Colony:new({
    --         type = 2,
    --         x = obj.x,
    --         y = obj.y,
    --         population = 0,
    --         width = obj.width,
    --         height = obj.height
    --     })
    -- end

end

return asset


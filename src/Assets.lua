local Colony = require("entities.Colony")
local Food = require("entities.Food")
local level1 = sti("levels/level-1.lua")

local asset = {}

function asset.generateWorldAssets()
    local red = 26 / 255
    local green = 154 / 255
    local blue = 105 / 255

    Lg.setBackgroundColor(red, green, blue)

    for _, obj in pairs(level1.layers["food"].objects) do
        table.insert(FoodCollection, Food:new(obj))
    end

    for _, obj in pairs(level1.layers["player_nest"].objects) do
        table.insert(Colonies, Colony:new(
                         {
                type = 1,
                x = obj.x,
                y = obj.y,
                population = 500,
                width = obj.width,
                height = obj.height
            }))
    end

    for _, obj in pairs(level1.layers["enemy_nest"].objects) do
        table.insert(Colonies, Colony:new(
                         {
                type = 2,
                x = obj.x,
                y = obj.y,
                population = 3000,
                width = obj.width,
                height = obj.height
            }))
    end

end

return asset

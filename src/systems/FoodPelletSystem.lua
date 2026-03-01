-- Removes food pellets from the engine and bump world once fully collected.
local FoodPelletSystem = class("FoodPelletSystem", System)

function FoodPelletSystem:requires()
    return { "foodPellet", "position", "food" }
end

function FoodPelletSystem:update()
    for _, entity in pairs(self.targets) do
        if entity:get("food").amount < 1 then
            engine:removeEntity(entity)
            if world:hasItem(entity) then world:remove(entity) end
        end
    end
end

return FoodPelletSystem

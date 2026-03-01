local FoodDrawSystem = class("FoodDrawSystem", System)

function FoodDrawSystem:requires()
    return { "position", "ant" }
end

function FoodDrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local antType  = entity.type
        if entity.hasFood then
            if entity.carryType == "body" then
                if antType == 1 then Lg.setColor(1, 0, 0) else Lg.setColor(0, 0, 0) end
                local x, y = position.x, position.y
                Lg.rectangle("fill", x - 3, y - 1, 6, 2)
                Lg.rectangle("fill", x - 1, y - 3, 2, 6)
            elseif entity.carryType == "spiderPart" then
                Lg.setColor(0.55, 0.30, 0.10)
                Lg.circle("fill", position.x, position.y, 3)
            else
                if antType == 1 then Lg.setColor(1, 0, 0) else Lg.setColor(0, 0, 0) end
                Lg.rectangle("fill", position.x, position.y, 2, 2)
            end
            Lg.setColor(1, 1, 1)
        end
    end
end

return FoodDrawSystem

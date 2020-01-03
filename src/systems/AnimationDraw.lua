-- Create a draw System.
local AnimationDrawSystem = class("AnimationDrawSystem", System)

function AnimationDrawSystem:requires()
    return {"position", "scale", "dimension", "animation"}
end

function AnimationDrawSystem:draw()
    for _, entity in pairs(self.targets) do
        local position = entity:get("position")
        local dimension = entity:get("dimension")
        local scale = entity:get("scale")

        entity.animation:draw(entity.image, position.x, position.y,
                              util.getAngle(entity.target.y, position.y,
                                            entity.target.x, position.x),
                              scale.amount, scale.amount,
                              util.getCenter(dimension.width),
                              util.getCenter(dimension.height))

    end

end

return AnimationDrawSystem

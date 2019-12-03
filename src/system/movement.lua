-- Movement System
System.movement = tiny.processingSystem()
System.movement.filter = tiny.requireAll("position", "velocity")
function System.movement:process(entity, delta_time)
    -- Clamp the velocity
    print('Hello')
end

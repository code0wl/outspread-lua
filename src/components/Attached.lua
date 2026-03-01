Components.Attached = Component.create("attached")

function Components.Attached:initialize(target, offsetX, offsetY)
    self.target = target
    self.offsetX = offsetX
    self.offsetY = offsetY
    self.attackTimer = 0.5
end

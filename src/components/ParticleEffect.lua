Components.ParticleEffect = Component.create("particleEffect")

function Components.ParticleEffect:initialize(psystem, duration, color, shockwave)
    self.psystem   = psystem
    self.timer     = 0
    self.duration  = duration  or 1
    self.color     = color     or {1, 1, 1}
    self.shockwave = shockwave or 0  -- max ring radius, 0 = disabled
end

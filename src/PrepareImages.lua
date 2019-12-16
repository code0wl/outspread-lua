BlackWalk = Lg.newImage("images/ants/spritesheets/ant1/_ant_walk-small.png")
RedWalk = Lg.newImage("images/ants/spritesheets/ant2/_ant_walk-small.png")
BlackWalkAnimationGrid = anim8.newGrid(16, 27, BlackWalk:getWidth(),
                                       BlackWalk:getHeight() + 1)
BlackWalkAnimation = anim8.newAnimation(BlackWalkAnimationGrid('1-5', 1, '1-5',
                                                               2, '1-5', 3),
                                        0.04)

RedWalkAnimationGrid = anim8.newGrid(16, 27, RedWalk:getWidth(),
                                     RedWalk:getHeight() + 1)
RedWalkAnimation = anim8.newAnimation(RedWalkAnimationGrid('1-5', 1, '1-5', 2,
                                                           '1-5', 3), 0.04)

DeadAntBlack = Lg.newImage("images/ants/spritesheets/ant1/_ant_dead-small.png")
DeadAntRed = Lg.newImage("images/ants/spritesheets/ant2/_ant_dead-small.png")

WalkingTarantula = Lg.newImage(
                       "images/spiders/spider1/spritesheets/sheet_spider_walk-small.png")

DeadTarantulaSpider = Lg.newImage(
                          "images/spiders/spider1/spritesheets/sheet_spider_die-small.png")

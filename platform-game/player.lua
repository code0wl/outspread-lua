player = {}
player.body = lp.newBody(myWorld, 100, 100, 'dynamic')
player.shape = lp.newRectangleShape(66, 92)
player.fixture = lp.newFixture(player.body, player.shape)

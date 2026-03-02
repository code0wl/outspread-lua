require("global")
require("Mouse")
require("PrepareImages")
require("HUD")

local Phermones       = require("entities.Phermones")
local Levels          = require("Levels")
local WorldMap        = require("Worldmap")
local OutSpreadEngine = require("OutSpreadEngine")
local Control         = require("Control")
local GameData        = require("GameData")
local SaveSystem      = require("SaveSystem")
local InsectSystem    = require("systems.InsectSystem")
local Colony          = require("entities.Colony")
local player          = Phermones:new()

function love.load()
    OutSpreadEngine.addSystems()
    GameData.init(Levels)
    InsectSystem.init()
end

function love.keypressed(key)
    if key == "f5" then SaveSystem.save(GameData) end
    if key == "f9" then SaveSystem.load(GameData) end
end

function love.update(dt)
    if BackgroundImage then
        BackgroundImage:setWrap("repeat", "repeat")
        QuadBQ = Lg.newQuad(0, 0, GlobalWidth, GlobalHeight, BackgroundImage:getWidth(), BackgroundImage:getHeight())
    end

    if GameState == 1 then
        Cam:setWorld(0, 0, GlobalWidth, GlobalHeight)
        engine:update(dt)
        InsectSystem.update(dt)

        -- Tick rival burrows: when timer expires, spawn enemy colony
        for i = #ActiveBurrows, 1, -1 do
            local b = ActiveBurrows[i]
            b.delay = b.delay - dt
            if b.delay <= 0 then
                local rv = b.rivals
                Colony:new({
                    type       = rv.type or 2,
                    x          = b.x,
                    y          = b.y,
                    population = math.floor((rv.population or 200) * 0.4),
                    width      = rv.width or 50,
                    height     = rv.height or 50,
                })
                GameData.addNotification(
                    "Enemy burrow opened! Red ants are swarming!",
                    { 1, 0.15, 0.1 }
                )
                table.remove(ActiveBurrows, i)
            end
        end

        -- Keep colony snapshot fresh for always-on HUD
        GameData.updateColonySnapshot()
    end

    if GameState == 2 then
        Cam:setWorld(0, 0, Lg.getWidth(), Lg.getHeight())
    end

    GameData.update(dt, Levels)
    Control.update(dt)
end

function love.draw()
    local mouseX, mouseY = Lm.getPosition()
    local currentX, currentY = Cam:getPosition()

    if GameState == 1 then
        Cam:draw(
            function(l, t, w, h)
                -- Dynamic tiling background
                Lg.draw(BackgroundImage, QuadBQ, 0, 0)

                -- Terrain decorations (rocks + vegetation) drawn beneath entities
                if CurrentLevelIdx then
                    local decor = GameData.levels[CurrentLevelIdx].decor
                    if decor then
                        for _, d in ipairs(decor) do
                            Lg.setColor(d.color[1], d.color[2], d.color[3], 0.88)
                            if d.kind == "rock" then
                                Lg.push()
                                Lg.translate(d.x + d.w * 0.5, d.y + d.h * 0.5)
                                Lg.rotate(d.rot)
                                Lg.rectangle("fill", -d.w * 0.5, -d.h * 0.5, d.w, d.h, 4, 4)
                                -- Highlight edge
                                Lg.setColor(1, 1, 1, 0.10)
                                Lg.rectangle("line", -d.w * 0.5, -d.h * 0.5, d.w, d.h, 4, 4)
                                Lg.pop()
                            elseif d.kind == "bush" then
                                Lg.ellipse("fill", d.x, d.y, d.r, d.r * 0.68)
                                Lg.setColor(d.color[1] * 0.6, d.color[2] * 0.65, d.color[3] * 0.5, 0.65)
                                Lg.ellipse("fill", d.x - d.r * 0.3, d.y - d.r * 0.25, d.r * 0.65, d.r * 0.5)
                            end
                        end
                        Lg.setColor(1, 1, 1, 1)
                    end
                end

                -- Rival burrows (red mound + progress arc)
                for _, b in ipairs(ActiveBurrows) do
                    local prog = 1 - math.max(0, b.delay / 45)
                    Lg.setColor(0.55 + prog * 0.35, 0.08, 0.05, 0.9)
                    Lg.ellipse("fill", b.x, b.y, 20, 11)
                    Lg.setColor(0.2, 0.03, 0.03, 0.8)
                    Lg.ellipse("fill", b.x, b.y, 9, 5)
                    Lg.setColor(1, 0.3, 0.1, 0.7)
                    Lg.setLineWidth(2)
                    Lg.arc("line", "open", b.x, b.y, 24, -math.pi * 0.5,
                        -math.pi * 0.5 + prog * math.pi * 2)
                    Lg.setLineWidth(1)
                    Lg.setColor(1, 1, 1, 1)
                end

                InsectSystem.draw()
                engine:draw()
                UpdateCameraLocation(mouseX, mouseY, currentX, currentY)
            end
        )
    end

    if GameState == 2 then
        Cam:draw(
            function(l, t, w, h)
                if GameState == 2 then
                    WorldMap:draw()
                    UpdateCameraLocation(mouseX, mouseY, currentX, currentY)
                end
            end
        )
    end

    Hud()

    suit.draw()
end

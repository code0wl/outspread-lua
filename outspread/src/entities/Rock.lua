local Rock = {}

function Rock(rockConfig)
    local rock = {}

    rock.width = rockConfig.width
    rock.height = rockConfig.height
    rock.x = rockConfig.x
    rock.y = rockConfig.y

    rock.isRock = true

    function rock.draw ()
        lg.setColor(255, 153, 153)
        lg.rectangle("fill", rock.x, rock.y, rock.width, rock.height)
    end

    return rock

end

return Rock

local lg       = _G.love.graphics
local graphics = { isCreated = lg and true or false }

function graphics.newSpriteBatch(...)
	if graphics.isCreated then
		return Lg.newSpriteBatch(...)
	end
end

function graphics.newCanvas(...)
	if graphics.isCreated then
		return Lg.newCanvas(...)
	end
end

function graphics.newImage(...)
	if graphics.isCreated then
		return Lg.newImage(...)
	end
end

function graphics.newQuad(...)
	if graphics.isCreated then
		return Lg.newQuad(...)
	end
end

function graphics.getCanvas(...)
	if graphics.isCreated then
		return Lg.getCanvas(...)
	end
end

function graphics.setCanvas(...)
	if graphics.isCreated then
		return Lg.setCanvas(...)
	end
end

function graphics.clear(...)
	if graphics.isCreated then
		return Lg.clear(...)
	end
end

function graphics.push(...)
	if graphics.isCreated then
		return Lg.push(...)
	end
end

function graphics.origin(...)
	if graphics.isCreated then
		return Lg.origin(...)
	end
end

function graphics.scale(...)
	if graphics.isCreated then
		return Lg.scale(...)
	end
end

function graphics.translate(...)
	if graphics.isCreated then
		return Lg.translate(...)
	end
end

function graphics.pop(...)
	if graphics.isCreated then
		return Lg.pop(...)
	end
end

function graphics.draw(...)
	if graphics.isCreated then
		return Lg.draw(...)
	end
end

function graphics.rectangle(...)
	if graphics.isCreated then
		return Lg.rectangle(...)
	end
end

function graphics.getColor(...)
	if graphics.isCreated then
		return Lg.getColor(...)
	end
end

function graphics.setColor(...)
	if graphics.isCreated then
		return Lg.setColor(...)
	end
end

function graphics.line(...)
	if graphics.isCreated then
		return Lg.line(...)
	end
end

function graphics.polygon(...)
	if graphics.isCreated then
		return Lg.polygon(...)
	end
end

function graphics.points(...)
	if graphics.isCreated then
		return Lg.points(...)
	end
end

function graphics.getWidth()
	if graphics.isCreated then
		return Lg.getWidth()
	end
	return 0
end

function graphics.getHeight()
	if graphics.isCreated then
		return Lg.getHeight()
	end
	return 0
end

return graphics

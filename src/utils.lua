local util = {}

function util.getCenter(value) return value / 2 end

function util.getAngle(y1, y2, x1, x2)
    return math.atan2(y1 - y2, x1 - x2) + math.pi
end

function util.distanceBetween(x1, y1, x2, y2)
    return math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
end

function util.generateRandomInteger(min, max)
    return math.floor(math.random() * (max - min + 1)) + min
end

function util.isOutOfBounds(element)
    return element.x < 0 or element.y < 0 or element.x > lg.getWidth() or
               element.y > lg.getHeight()
end

function util.CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function util.logTable(node)
    local cache, stack, output = {}, {}, {}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k, v in pairs(node) do size = size + 1 end

        local cur_index = 1
        for k, v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str, "}", output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str, "\n", output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output, output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "[" .. tostring(k) .. "]"
                else
                    key = "['" .. tostring(k) .. "']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t', depth) .. key ..
                                     " = " .. tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t', depth) .. key ..
                                     " = {\n"
                    table.insert(stack, node)
                    table.insert(stack, v)
                    cache[node] = cur_index + 1
                    break
                else
                    output_str = output_str .. string.rep('\t', depth) .. key ..
                                     " = '" .. tostring(v) .. "'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" ..
                                     string.rep('\t', depth - 1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" ..
                                     string.rep('\t', depth - 1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t', depth - 1) ..
                             "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output, output_str)
    output_str = table.concat(output)

end

function util.setDirectionToTarget(actor, dt)
    local speed = actor.speed * dt
    actor.body:setX((actor.body:getX() -
                        math.cos(util.getAngle(actor.target.y,
                                               actor.body:getX(),
                                               actor.target.x, actor.body:getX())) *
                        speed))
    actor.body:setY((actor.body:getY() -
                        math.sin(util.getAngle(actor.target.y,
                                               actor.body:getY(),
                                               actor.target.x, actor.body:getX())) *
                        speed))
end

return util

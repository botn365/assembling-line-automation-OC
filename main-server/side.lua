side = {}
---@param direction string
---@return integer
function side:get(direction)
    local sides = {"d","u","n","s","w","e"}
    for i = 0 , 5 do
        if direction ==  sides[i+1] then
            return i
        end
    end
    return nil
end

---@param direction string
---@param anchor string
---@return integer
function side:getSided(direction,anchor)
    local sides =  {"n","e","s","w"}
    for i = 0, 3 do
        if anchor == sides[i+1] then
            local add = nil
            for j = 0, 3 do
                if direction == sides[j+1] then
                    add = j
                    break;
                end
            end
            if add ~= nil then
                return side:get(sides[((add+i)%4)+1])
            end
        end
    end
end

return side

local process = {}

function process.setSide(direction)
    local dir = {}
    if direction == "N" then
        dir.directionitem = {}
        dir.directionfluid1 = {}
        dir.directionfluid2 = {}
    elseif direction == "E" then
        dir.directionitem = {}
        dir.directionfluid1 = {}
        dir.directionfluid2 = {}
    elseif direction == "S" then
        dir.directionitem = {}
        dir.directionfluid1 = {}
        dir.directionfluid2 = {}
    elseif direction == "W" then
        dir.directionitem = {}
        dir.directionfluid1 = {}
        dir.directionfluid2 = {}
    end
    if direction == "U" then
        dir.directionitem = {}
        dir.directionfluid1 = {}
        dir.directionfluid2 = {}
    elseif direction == "D" then
        dir.directionitem = {}
        dir.directionfluid1 = {}
        dir.directionfluid2 = {}
    end
    return dir
end

return process
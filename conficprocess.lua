local component = require("component")
local process = {}

function process.setSide(direction)
    local dir = {}
    if direction == "N" then
        dir.directionitem = {5,4,0}
        dir.directionfluid1 = {0,1,2,3,4,5}
        dir.directionfluid2 = {1,3,4,0,5}
        dir.directionredstoneassline = 2
        dir.directionredstoneloader = 3
    elseif direction == "E" then
        dir.directionitem = {3,2,0}
        dir.directionfluid1 = {0,1,5,4,2,3}
        dir.directionfluid2 = {1,4,2,0,3}
        dir.directionredstoneassline = 5
        dir.directionredstoneloader = 4
    elseif direction == "S" then
        dir.directionitem = {4,5,0}
        dir.directionfluid1 = {0,1,3,2,5,4}
        dir.directionfluid2 = {1,2,5,0,4}
        dir.directionredstoneassline = 3
        dir.directionredstoneloader = 2
    elseif direction == "W" then
        dir.directionitem = {2,3,0}
        dir.directionfluid1 = {0,1,4,5,3,2}
        dir.directionfluid2 = {1,5,4,0,2}
        dir.directionredstoneassline = 4
        dir.directionredstoneloader = 5
    end
    if direction == "U" then
        dir.directionredstoneassline = 1
    elseif direction == "D" then
        dir.directionredstoneassline = 0
    end
    return dir
end

function process.setProxyA(addr)
    local proxys = {}
    for k , v in pairs(addr) do
        proxys[k] = component.proxy(addr[k])
    end
    return proxys
end

function process.setProxy(addr)
    return component.proxy(addr)
end

function process.setSideA(dir)
local directiotable = {}
    for k , v in pairs(dir) do
        directiotable[k] = process.setSide(dir[k]).directionredstoneassline
    end
    return directiotable
end

return process

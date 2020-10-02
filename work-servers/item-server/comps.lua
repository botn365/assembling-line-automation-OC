local component = require("component")
local filesystem = require("filesystem")
local components = {}

 function components.newComp(address,func,index)
    local object = {}
    if address == nil then
        object.component = nil
    else
        object.component = component.proxy(address)
    end
    object.func = func
    object.index = index
    function object.fromString(input)
        local posStart = 1
        local posEnd = string.find(input,",")
        object.component = component.proxy(string.sub(input,posStart,posEnd-1))
        if object.component == nil then
            return nil
        end
        posStart = posEnd+1
        posEnd = string.find(input,",",posStart)
        object.func = string.sub(input,posStart,posEnd-1)
        object.index = tonumber(string.sub(input,posEnd+1,#input))
    end
    function object.toString()
        local returnValue = object.component.address
        returnValue = returnValue .. "," .. object.func..","..object.index
        return returnValue
    end
    return object
end

function components.getComponnents(path)
    if not filesystem.exists(path) then
        local f = io.open(path,"w")
        f:close()
    end
    local file = io.open(path)
    local offset = 0
    local hasErrord = false
    local comps = {}
    repeat
        file:seek("set",offset)
        local read = file:read(100)
        if read == nil then
            hasErrord = true
            break
        end
        local pos1 = string.find(read, "{")
        --if pos1 == nil then break end
        if pos1 == nil then
            hasErrord = true
            break
        end
        pos1 = pos1 + 1
        local pos2 = string.find(read,"}")-1
        local compString = string.sub(read,pos1,pos2)
        local component = components.newComp()
        component.fromString(compString)
        if component.component == nil then
            hasErrord = true
            break
        end
        comps[#comps+1] = component
        offset = offset + pos2+2
    until string.find(read,",",pos2) == nil
    file:close()
    if hasErrord then
        return nil
    end
    return comps
end

function components.storeComponents(comps,path,append)
    if not filesystem.exists(path) then
        local f = io.open(path,"w")
        f:close()
    end
    append = append or false;
    local writeType = "w"
    if append then
        writeType = "a"
    end
    local file = io.open(path,writeType)
    local writeString = ""
    if append then 
        writeString = ","
    end
    for k,comp in pairs(comps) do
        if k ~= 1 then
            writeString = writeString..","
        end
        writeString = writeString.."{"..comp.toString().."}"
    end
    file:write(writeString)
    file:close()
end

return components
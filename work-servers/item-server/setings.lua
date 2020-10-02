local setings = {}
local filesystem = require("filesystem")

function setings.set(path,varStoreArray,...)
    setings.path = path
    setings.vars = varStoreArray
    for k,seting in pairs({...}) do
        setings.vars[seting] = false
    end
end

function setings.load()
    if setings.path == nil then
        return false
    end
    if not filesystem.exists(setings.path) then
        local f = io.open(setings.path, "w")
        f:close()
    end
    local fileIndex = 0
    local file = io.open(setings.path)
    for k,v in pairs(setings.vars) do
        local read = file:read(100)
        if read == nil then
            read = "a"
        end
        local index = string.find(read,"{")
        if index ~= nil then
            local startPos = string.find(read,"=",index) + 1
            local key = string.sub(read,index+1,startPos-2)
            local endPos = string.find(read,",",startPos)-1
            local typePos = string.find(read,"}",endPos)-1
            local type = string.sub(read,endPos+2,typePos)
            local value = string.sub(read,startPos,endPos)
            value = setings.fromString(value,type)
            setings.vars[key] = value
            fileIndex = fileIndex + typePos + 1
            file:seek("set", fileIndex)
        end
    end
    file:close()
end

function setings.toString(value)
    local type = type(value)
    if type == "boolean" then
        if value then
            return "true","boolean"
        else
            return "false","boolean"
        end
    else
        return value,type
    end
end

function setings.fromString(value,type)
    if type == "boolean" then
        if value == "true" then
            return true
        end
        return false
    elseif type == "string" then
        return value
    elseif type == "number" then
        return tonumber(value)
    end
    return nil
end

function setings.save()
    local file = io.open(setings.path,"w")
    for k,v in pairs(setings.vars) do
        local value,type = setings.toString(v)
        file:write("{"..k.."="..value..","..type.."}")
    end
    file:close()
end

return setings